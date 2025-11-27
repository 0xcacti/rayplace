#include "raylib.h"

int main(void) {
  SetConfigFlags(FLAG_WINDOW_UNDECORATED);
  InitWindow(600, 600, "rayplace");
  SetTargetFPS(60);

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(BLACK);
    DrawText("Hello, raylib!", 300, 280, 20, DARKGRAY);
    EndDrawing();
  }

  CloseWindow();
  return 0;
}
