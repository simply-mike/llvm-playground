# One-Dimensional Cellular Automaton with SDL2

This project visualizes a **one-dimensional cellular automaton** using **Rule 110**, one of the simplest known Turing-complete systems. The simulation runs in real time and is rendered using a minimal custom graphics layer built on top of **SDL 2.0**.

Each row represents a new generation of the automaton, evolving downward from an initial random state. The result is a striking space-time diagram that reveals complex emergent behavior from a simple local rule.

## Features

- **Rule 110 Automaton**: Implements the elementary cellular automaton rule 110.
- **Cyclic Boundary Conditions**: The left and right edges wrap around (toroidal topology).
- **Real-time Visualization**: Each new generation is drawn immediately below the previous one.
- **No External Dependencies** beyond SDL2.

## What is Rule 110?

Rule 110 is an **elementary cellular automaton** defined by the following update rule for each cell based on its current state and the states of its left and right neighbors:

| Left | Center | Right | -> | New State |
|------|--------|-------|---|-----------|
| 1    | 1      | 1     | -> | 0         |
| 1    | 1      | 0     | -> | 1         |
| 1    | 0      | 1     | -> | 1         |
| 1    | 0      | 0     | -> | 0         |
| 0    | 1      | 1     | -> | 1         |
| 0    | 1      | 0     | -> | 1         |
| 0    | 0      | 1     | -> | 1         |
| 0    | 0      | 0     | -> | 0         |

This rule is notable because it is **computationally universal** — capable of simulating any Turing machine given the right initial conditions.

## Requirements

- `libsdl2-dev`
- `clang` (17 recommended)
- `cmake` (3.20 or higher)

### On Debian/Ubuntu:

```bash
sudo apt update
sudo apt install libsdl2-dev build-essential
```

## Building and Running

This project uses **CMake** as its build system. Ensure you have CMake, a C compiler (like `clang`), and SDL2 development libraries installed.

### Step 1: Build the application

It's recommended to build out-of-source:

```bash
cd 00-SDL
mkdir build
cd build
cmake ..
cmake --build .
```
If you have different LLVM version by default and another version is installed separately (like llvm-config-17), last step should be something like:

```bash
cmake .. -DLLVM_DIR=$(llvm-config-17 --cmakedir)
```

### Step 2: Run the application

```bash
./GUI-app
```


### Optional: Clean

To clean all build artifacts:

```bash
rm -rf *
```

or delete the entire `build/` directory.

## Controls

- Close the window or press `Alt+F4` to exit.

## Architecture

- `start.c` — Application entry point.
- `GUI-lib.c` / `GUI-lib.h` — Minimal SDL2 wrapper providing `gui_set_pixel`, `gui_flush`, `gui_quit_event`, and `gui_rand`.
- `app.c` — Core logic:
  - Initializes the first row with random live/dead cells.
  - Applies Rule 110 with wrap-around boundaries.
  - Renders each generation as a horizontal line of pixels.

## Visualization Details

- The screen is treated as a grid of `GUI_WIDTH × GUI_HEIGHT` logical pixels.
- Each logical pixel maps 1:1 to a real screen pixel (no scaling).
- Time flows downward: row 0 = initial state, row 1 = next generation, etc.
- Once the bottom is reached, the display wraps and overwrites from the top.

## Why Rule 110?

Despite its simplicity, Rule 110 exhibits **complex, chaotic, and structured behavior** simultaneously — a hallmark of systems capable of universal computation. This project offers a live window into that fascinating computational universe.

## References

- [SDL2 Documentation](https://wiki.libsdl.org/SDL2)
- [Elementary Cellular Automaton — Wikipedia](https://en.wikipedia.org/wiki/Elementary_cellular_automaton)
- [Rule 110 — Wolfram MathWorld](https://mathworld.wolfram.com/Rule110.html)

## License

This project is distributed under the **zlib license**, the same as SDL2.  
See [libsdl.org](https://www.libsdl.org/) for license details.
