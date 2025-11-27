#include "raylib.h"
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  Texture2D *textures;
  int count;
} Wallpapers;

typedef struct {
  float x, y;
  float width, height;
} ThumbnailBounds;

Wallpapers loadWallpapers(const char *directoryPath) {
  (void)directoryPath; // Unused parameter
  Wallpapers result = {0};
  result.count = 3;
  Texture2D *textures = malloc(sizeof(Texture2D) * 3);
  Image wp1 = LoadImage("resources/low-poly.png");
  Texture2D t1 = LoadTextureFromImage(wp1);
  UnloadImage(wp1);

  Image wp2 = LoadImage("resources/gear-five.jpeg");
  Texture2D t2 = LoadTextureFromImage(wp2);
  UnloadImage(wp2);

  Image wp3 = LoadImage("resources/taiga.jpg");
  Texture2D t3 = LoadTextureFromImage(wp3);
  UnloadImage(wp3);

  textures[0] = t1;
  textures[1] = t2;
  textures[2] = t3;
  result.textures = textures;
  return result;
}

ThumbnailBounds calculateThumbnailBounds(int col, int itemWidth, int itemHeight, int xPadding,
                                         int yPadding) {
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
                 (Rectangle){offsetX, offsetY, scaledWidth, scaledHeight}, (Vector2){0, 0}, 0.0f,
                 WHITE);

  if (!isActive) {
    DrawRectangle(bounds.x, bounds.y, bounds.width, bounds.height, (Color){0, 0, 0, 100});
  }

  EndScissorMode();
}

int main(void) {
  SetConfigFlags(FLAG_WINDOW_UNDECORATED);
  int windowWidth = 350;
  int windowHeight = 100;
  InitWindow(windowWidth, windowHeight, "rayplace");

  int screenWidth = GetMonitorWidth(0);
  int screenHeight = GetMonitorHeight(0);

  SetWindowPosition(screenWidth / 2 - windowWidth / 2, screenHeight / 2 - windowHeight / 2);
  SetTargetFPS(60);

  int yPadding = 8;
  int xPadding = 5;
  int columns = 3;
  int itemWidth = (windowWidth - xPadding * (columns + 1)) / columns;
  int itemHeight = windowHeight - yPadding * 2;

  Wallpapers wallpapers = loadWallpapers("resources/");

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(BLACK);

    for (int col = 0; col < columns; col++) {
      ThumbnailBounds bounds =
          calculateThumbnailBounds(col, itemWidth, itemHeight, xPadding, yPadding);
      drawThumbnail(wallpapers.textures[col], bounds, col == 1);
    }

    EndDrawing();
  }

  CloseWindow();
  return 0;
}
