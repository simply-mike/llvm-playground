# Conway's Game of Life with SDL2

This project implements **Conway's Game of Life** using a simple custom graphics interface built on top of **SDL 2.0**. The application visualizes the cellular automaton on a grid, where each cell is represented as a virtual pixel (8x8 real pixels) for better visibility and performance.

## Features

- **Virtual Pixels**: Each logical cell is rendered as an 8x8 block of real pixels for clarity.
- **Real-time Simulation**: Watch the evolution of cellular patterns in real-time.
- **Simple Interface**: A custom `sim.h` provides a minimal API for graphics, hiding the complexity of SDL.
- **Pure C**: Uses only C standard types (`int`) and static memory allocation.
- **No External Dependencies**: Only requires SDL2 and standard C libraries.

## Rules of Conway's Game of Life

The universe of the Game of Life is an infinite, two-dimensional orthogonal grid of square cells, each of which is in one of two possible states: alive or dead.

Every cell interacts with its eight neighbors, which are the cells that are horizontally, vertically, or diagonally adjacent. At each step in time, the following transitions occur:

1. Any live cell with fewer than two live neighbors dies, as if by underpopulation.
2. Any live cell with two or three live neighbors lives on to the next generation.
3. Any live cell with more than three live neighbors dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.

## Notable Patterns

- **Still lifes**: Patterns that do not change. Examples: Block, Beehive, Loaf.
- **Oscillators**: Patterns that return to their initial state after a finite number of generations. Example: Blinker, Toad.
- **Spaceships**: Patterns that move across the grid. Example: Glider, Lightweight Spaceship.
- **Guns**: Patterns that periodically emit spaceships. Example: Gosper Glider Gun.

## Requirements

- `SDL2`
- `clang`
- `make`

## Installation and Usage

### On Debian/Ubuntu:

```bash
sudo apt update
sudo apt install libsdl2-dev build-essential
```

## Building and Running

This project includes a `Makefile` for easy building and running.

### Build the executable:

```bash
make
```

### Run the application:

```bash
make run
```

### Clean build artifacts:

```bash
make clean
```

## Controls

- Close the window or press `Alt+F4` to exit the application.

## Architecture

- `start.c`: Entry point of the application.
- `sim.c` / `sim.h`: Provides a simplified graphics interface using SDL2. Includes functions like `simPutPixel`, `simFlush`, `simDelay`, etc.
- `app.c`: Contains the logic for Conway's Game of Life, including grid updates and rendering.

## How It Works

- The grid is logically smaller (`VIRTUAL_WIDTH x VIRTUAL_HEIGHT`) than the actual screen resolution (`SIM_X_SIZE x SIM_Y_SIZE`).
- Each logical cell is mapped to an 8x8 square of real pixels for rendering.
- The simulation updates the grid based on Conway's Game of Life rules every frame.
- A delay (`simDelay`) controls the simulation speed.

- [SDL2 Documentation](https://wiki.libsdl.org/SDL2)

## License

This project is distributed under the same license as SDL2: the zlib license. See [SDL's website](https://www.libsdl.org/) for more details.
