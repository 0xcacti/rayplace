#include "raylib.h"

int main(void) {
  SetConfigFlags(FLAG_WINDOW_UNDECORATED);
  int windowWidth = 300;
  int windowHeight = 100;
  InitWindow(windowWidth, windowHeight, "rayplace");

  int screenWidth = GetMonitorWidth(0);
  int screenHeight = GetMonitorHeight(0);

  SetWindowPosition(screenWidth / 2 - windowWidth / 2, screenHeight / 2 - windowHeight / 2);
  SetTargetFPS(60);

  Image wallpaper = LoadImage("resources/low-poly.png");
  Texture2D texture = LoadTextureFromImage(wallpaper);
  UnloadImage(wallpaper);

  int yPadding = 5;
  int xPadding = 3;
  int columns = 3;
  int itemWidth = (windowWidth - xPadding * (columns + 1)) / columns;
  int itemHeight = windowHeight - yPadding * 2;

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(BLACK);

    // Draw single row of thumbnails
    for (int col = 0; col < columns; col++) {
      float x = xPadding + col * (itemWidth + xPadding);
      float y = yPadding;

      // Calculate scale to fit thumbnail while preserving aspect ratio
      float scaleX = (float)itemWidth / texture.width;
      float scaleY = (float)itemHeight / texture.height;
      float scale = (scaleX < scaleY) ? scaleX : scaleY;

      float scaledWidth = texture.width * scale;
      float scaledHeight = texture.height * scale;

      // Center within thumbnail area
      float offsetX = x + (itemWidth - scaledWidth) / 2;
      float offsetY = y + (itemHeight - scaledHeight) / 2;

      DrawTexturePro(texture, (Rectangle){0, 0, texture.width, texture.height},
                     (Rectangle){offsetX, offsetY, scaledWidth, scaledHeight}, (Vector2){0, 0},
                     0.0f, WHITE);
    }

    DrawRectangleLinesEx((Rectangle){1, 1, windowWidth - 2, windowHeight - 2}, 1,
                         (Color){255, 255, 255, 50});

    EndDrawing();
  }

  CloseWindow();
  return 0;
}
