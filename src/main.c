#include "raylib.h"

int main(void) {
  int windowWidth = 400;
  int windowHeight = 150;

  SetConfigFlags(FLAG_WINDOW_UNDECORATED);
  InitWindow(windowWidth, windowHeight, "rayplace");

  int screenWidth = GetMonitorWidth(0);
  int screenHeight = GetMonitorHeight(0);

  SetWindowPosition(screenWidth / 2 - windowWidth / 2, screenHeight / 2 - windowHeight / 2);
  SetTargetFPS(60);

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(BLACK);

    // Subtle inner border glow
    DrawRectangleLinesEx((Rectangle){1, 1, windowWidth - 2, windowHeight - 2}, 1,
                         (Color){255, 255, 255, 50});

    EndDrawing();
  }

  CloseWindow();
  return 0;
}
