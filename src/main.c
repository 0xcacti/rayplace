#include "raylib.h"
#include <dirent.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DISPLAYED_WALLPAPERS 3

typedef struct {
  Texture2D *textures;
  int count;
  int sliceStartIdx;
  int sliceCount;
} Wallpapers;

typedef struct {
  int indices[DISPLAYED_WALLPAPERS];
} WallpaperSlice;

typedef struct {
  float x, y;
  float width, height;
} ThumbnailBounds;

typedef struct {
  int direction;
  float t;
  float duration;
  WallpaperSlice fromSlice;
  WallpaperSlice toSlice;
} SlideAnimation;

const char *getFileExtension(const char *filename) {
  const char *dot = strrchr(filename, '.');
  if (!dot || dot == filename)
    return "";
  return dot + 1;
}

bool isValidExtension(const char *extension) {
  return (strcmp(extension, "png") == 0 || strcmp(extension, "jpg") == 0 ||
          strcmp(extension, "jpeg") == 0);
}

char **getWallpaperPaths(const char *directoryPath, int *outCount) {
  DIR *d;
  struct dirent *dir;
  d = opendir(directoryPath);

  int pathsCap = 5;
  char **paths = malloc(pathsCap * sizeof(char *));

  if (!d) {
    perror("opendir");
    exit(EXIT_FAILURE);
  }
  while ((dir = readdir(d)) != NULL) {
    if (isValidExtension(getFileExtension(dir->d_name))) {
      if (*outCount >= pathsCap) {
        pathsCap *= 2;
        paths = realloc(paths, pathsCap * sizeof(char *));
        if (!paths) {
          perror("malloc");
          exit(EXIT_FAILURE);
        }
      }
      char *path = malloc(strlen(directoryPath) + strlen(dir->d_name) + 1);
      if (!path) {
        perror("malloc");
        exit(EXIT_FAILURE);
      }
      snprintf(path, strlen(directoryPath) + strlen(dir->d_name) + 2, "%s/%s",
               directoryPath, dir->d_name);
      paths[*outCount] = path;
      (*outCount)++;
    }
  }
  closedir(d);
  return paths;
}

Wallpapers loadWallpapers(char **wallpaperPaths, int count) {

  Wallpapers wallpapers = {0};
  wallpapers.sliceStartIdx = 0;
  wallpapers.sliceCount = DISPLAYED_WALLPAPERS;
  wallpapers.count = count;
  wallpapers.textures = malloc(sizeof(Texture2D) * count);

  for (int i = 0; i < count; i++) {
    Image img = LoadImage(wallpaperPaths[i]);
    Texture2D texture = LoadTextureFromImage(img);
    UnloadImage(img);
    wallpapers.textures[i] = texture;
  }

  return wallpapers;
}

void moveSliceWindow(Wallpapers *wallpapers, int direction) {
  int newStartIdx = wallpapers->sliceStartIdx + direction;
  if (newStartIdx < 0) {
    newStartIdx = wallpapers->count - 1;
  }
  if (newStartIdx >= wallpapers->count) {
    newStartIdx = 0;
  }
  wallpapers->sliceStartIdx = newStartIdx;
}

WallpaperSlice getCurrentSliceIndices(Wallpapers *wallpapers) {
  WallpaperSlice slice = {0};
  for (int i = 0; i < wallpapers->sliceCount; i++) {
    int idx = (wallpapers->sliceStartIdx + i) % wallpapers->count;
    slice.indices[i] = idx;
  }
  return slice;
}

ThumbnailBounds calculateThumbnailBounds(int col, int itemWidth, int itemHeight,
                                         int xPadding, int yPadding) {
  ThumbnailBounds bounds = {0};
  bounds.x = xPadding + col * (itemWidth + xPadding);
  bounds.y = yPadding;
  bounds.width = (float)itemWidth;
  bounds.height = (float)itemHeight;
  return bounds;
}

void drawThumbnail(Texture2D texture, ThumbnailBounds bounds, bool isActive) {

  float scaleX = bounds.width / texture.width;
  float scaleY = bounds.height / texture.height;
  float scale = (scaleX > scaleY) ? scaleX : scaleY;

  float scaledWidth = texture.width * scale;
  float scaledHeight = texture.height * scale;

  float offsetX = bounds.x + (bounds.width - scaledWidth) / 2;
  float offsetY = bounds.y + (bounds.height - scaledHeight) / 2;

  BeginScissorMode(bounds.x, bounds.y, bounds.width, bounds.height);

  DrawTexturePro(texture, (Rectangle){0, 0, texture.width, texture.height},
                 (Rectangle){offsetX, offsetY, scaledWidth, scaledHeight},
                 (Vector2){0, 0}, 0.0f, WHITE);

  if (!isActive) {
    DrawRectangle(bounds.x, bounds.y, bounds.width, bounds.height,
                  (Color){0, 0, 0, 150});
  }

  EndScissorMode();
}

int main(int argc, char **argv) {

  char *resourcePath = NULL;
  if (argc < 2) {
    resourcePath = "resources";
  } else {
    resourcePath = argv[1];
  }

  int wpCount = 0;
  char **paths = getWallpaperPaths(resourcePath, &wpCount);

  SetConfigFlags(FLAG_WINDOW_UNDECORATED);
  int windowWidth = 350;
  int windowHeight = 100;
  InitWindow(windowWidth, windowHeight, "rayplace");
  SetWindowFocused();

  int screenWidth = GetMonitorWidth(0);
  int screenHeight = GetMonitorHeight(0);

  SetWindowPosition(screenWidth / 2 - windowWidth / 2,
                    screenHeight / 2 - windowHeight / 2);
  SetTargetFPS(60);

  int yPadding = 8;
  int xPadding = 5;
  int columns = DISPLAYED_WALLPAPERS;
  int itemWidth = (windowWidth - xPadding * (columns + 1)) / columns;
  int itemHeight = windowHeight - yPadding * 2;

  Wallpapers wallpapers = loadWallpapers(paths, wpCount);
  SlideAnimation slide = {0};
  slide.duration = 0.25f;

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(BLACK);

    float dt = GetFrameTime();
    if (slide.direction != 0) {
      slide.t += dt / slide.duration;
      if (slide.t >= 1.0f) {
        slide.t = 1.0f;
        slide.direction = 0;
      }
    }
    int ch = GetCharPressed();
    while (ch != 0) {
      if (slide.direction == 0 && ch == 'h') {
        slide.fromSlice = getCurrentSliceIndices(&wallpapers);
        moveSliceWindow(&wallpapers, -1);
        slide.toSlice = getCurrentSliceIndices(&wallpapers);
        slide.direction = 1;
        slide.t = 0.0f;
      }
      if (slide.direction == 0 && ch == 'l') {
        slide.fromSlice = getCurrentSliceIndices(&wallpapers);
        moveSliceWindow(&wallpapers, 1);
        slide.toSlice = getCurrentSliceIndices(&wallpapers);
        slide.direction = -1;
        slide.t = 0.0f;
      }
      ch = GetCharPressed();
    }

    WallpaperSlice slice = getCurrentSliceIndices(&wallpapers);
    if (slide.direction == 0) {
      for (int i = 0; i < DISPLAYED_WALLPAPERS; i++) {
        ThumbnailBounds bounds = calculateThumbnailBounds(
            i, itemWidth, itemHeight, xPadding, yPadding);
        drawThumbnail(wallpapers.textures[slice.indices[i]], bounds, i == 1);
      }
    } else {
      float progress = slide.t;
      float slideDistance = (float)(itemWidth + xPadding);
      float dir = (float)slide.direction;

      for (int i = 0; i < DISPLAYED_WALLPAPERS; i++) {
        ThumbnailBounds base = calculateThumbnailBounds(
            i, itemWidth, itemHeight, xPadding, yPadding);

        ThumbnailBounds fromB = base;
        ThumbnailBounds toB = base;

        fromB.x = base.x + dir * slideDistance * progress;
        toB.x = base.x + dir * slideDistance * (progress - 1.0f);

        drawThumbnail(wallpapers.textures[slide.fromSlice.indices[i]], fromB,
                      i == 1 && progress < 0.5f);
      }
    }
    EndDrawing();
  }

  CloseWindow();
  return 0;
}
