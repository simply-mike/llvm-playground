# LLVM IR Builder

This project **programmatically constructs LLVM IR** for the **cellular automaton** using LLVM’s C++ API, then **executes it at runtime via LLVM’s JIT engine**. Unlike `00-SDL`, which compiles C code, this implementation builds the entire program logic — including loops, conditionals, and memory operations — directly in LLVM IR.

The generated IR is equivalent to the hand-written C version (`app.ll`), but created entirely through code. The JIT engine links it with the SDL2-based GUI runtime (`GUI-lib.c`) to produce a live visualization.

## Features

- **Full IR Construction**: Every basic block, PHI node, and instruction is built manually.
- **JIT Execution**: Uses LLVM’s deprecated but functional `EngineBuilder` to compile and run IR in-process.
- **Native GUI Integration**: Dynamically links generated IR with `gui_rand`, `gui_set_pixel`, `gui_flush`, and `gui_quit_event` from `00-SDL`.
- **LLVM 17 Compatible**: Works with Clang/LLVM 17 despite using legacy JIT APIs.
- **Self-Contained**: No external `.ll` files — IR is generated and executed on the fly.

## Requirements

- `libsdl2-dev`
- `clang` (17 recommended)
- `llvm-dev` (17 recommended)
- `cmake` (3.20 or higher)

## Building and Running

```bash
cd 02-LLVM-IR-Builder
mkdir build && cd build
cmake ..
cmake --build .
./IR_Gen > jit-ir.ll
```

If you have different LLVM version by default and another version is installed separately (like llvm-17), `cmake ..` step should be something like:

```bash
cmake .. --DCMAKE_C_COMPILER=clang-17
```

The program will:
1. Print the generated LLVM IR to jit-ir.ll
2. Initialize the SDL2 window
3. Run the automaton in real time
4. Exit when the window is closed

## Architecture

- `src/IR-builder.cpp` - Full IR construction and JIT execution

Relies on:
- `../00-SDL/lib/GUI-lib.c` - SDL2 wrapper implementation
- `../00-SDL/include/GUI-lib.h` - function declarations

## Notes

- This project uses **deprecated LLVM APIs** (`EngineBuilder`, `ExecutionEngine`), which are still available in LLVM 17 but **removed in LLVM 18+**.

## License

This project is distributed under the **zlib license**, the same as SDL2.  
See [libsdl.org](https://www.libsdl.org/) for license details.