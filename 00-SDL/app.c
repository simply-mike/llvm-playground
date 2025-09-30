#include "sim.h"

#define PIXEL_SIZE 8
#define VIRTUAL_WIDTH (SIM_X_SIZE / PIXEL_SIZE)
#define VIRTUAL_HEIGHT (SIM_Y_SIZE / PIXEL_SIZE)

#define WHITE_COLOR 0xFFFFFFFF
#define BLACK_COLOR 0xFF000000

#define USED_DELAY_MS 100

int countNeighbors(int grid[VIRTUAL_HEIGHT][VIRTUAL_WIDTH], int x, int y) {
  int count = 0;
  for (int dy = -1; dy <= 1; dy++) {
    for (int dx = -1; dx <= 1; dx++) {
      if (dx == 0 && dy == 0)
        continue;
      int nx = x + dx;
      int ny = y + dy;
      if (nx >= 0 && nx < VIRTUAL_WIDTH && ny >= 0 && ny < VIRTUAL_HEIGHT) {
        if (grid[ny][nx] == 1) {
          count++;
        }
      }
    }
  }
  return count;
}

void app(void) {
  int grid[VIRTUAL_HEIGHT][VIRTUAL_WIDTH];
  int tempGrid[VIRTUAL_HEIGHT][VIRTUAL_WIDTH];

  for (int y = 0; y < VIRTUAL_HEIGHT; y++) {
    for (int x = 0; x < VIRTUAL_WIDTH; x++) {
      grid[y][x] = simRand() % 2; // random fill
    }
  }

  while (1) {
    for (int vy = 0; vy < VIRTUAL_HEIGHT; vy++) {
      for (int vx = 0; vx < VIRTUAL_WIDTH; vx++) {
        int color = grid[vy][vx] ? WHITE_COLOR : BLACK_COLOR;

        for (int dy = 0; dy < PIXEL_SIZE; dy++) {
          for (int dx = 0; dx < PIXEL_SIZE; dx++) {
            int x = vx * PIXEL_SIZE + dx;
            int y = vy * PIXEL_SIZE + dy;
            simPutPixel(x, y, color);
          }
        }
      }
    }

    simFlush();
    simDelay(USED_DELAY_MS);

    for (int vy = 0; vy < VIRTUAL_HEIGHT; vy++) {
      for (int vx = 0; vx < VIRTUAL_WIDTH; vx++) {
        int neighbors = countNeighbors(grid, vx, vy);
        if (grid[vy][vx] == 1) {
          tempGrid[vy][vx] = (neighbors == 2 || neighbors == 3) ? 1 : 0;
        } else {
          tempGrid[vy][vx] = (neighbors == 3) ? 1 : 0;
        }
      }
    }

    for (int vy = 0; vy < VIRTUAL_HEIGHT; vy++) {
      for (int vx = 0; vx < VIRTUAL_WIDTH; vx++) {
        grid[vy][vx] = tempGrid[vy][vx];
      }
    }
  }
}
