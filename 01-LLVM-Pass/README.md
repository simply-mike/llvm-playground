# LLVM IR Instruction Tracer for Conway's Game of Life

This project implements an **instrumenting LLVM pass** that dynamically traces the execution of LLVM IR instructions in the `app.c` module of the Conway's Game of Life application (from `../00-SDL`). The pass collects a runtime trace of instruction opcodes and enables statistical analysis of frequently occurring instruction patterns of length 1 to 5.

The instrumentation is applied **only to the core logic (`app.c`)**, leaving the SDL2 rendering and main loop untouched—ensuring focused and efficient analysis.

## Features

- **Selective Instrumentation**: Only `app.c` is instrumented; `start.c` and `sim.c` remain unmodified.
- **Dynamic Trace Collection**: Records actual IR instructions executed at runtime (not static IR).
- **PHI-Node Exclusion**: Skips `phi` instructions, as they are artifacts of SSA form and not executed directly.
- **LLVM 20+ Compatible**: Uses modern LLVM APIs (`PointerType::get`, `CreateGlobalString`, updated pass callbacks).
- **Pattern Analysis**: Includes a Python script to extract and visualize top instruction sequences (1–5 long).

## How It Works

1. The LLVM pass inserts a call to `printInstr("opcode")` before every non-`phi` IR instruction in `app.c`.
2. When the instrumented binary runs, it prints each executed opcode to `stdout`.
3. A Python analysis script captures this trace, counts n-gram patterns (1 ≤ n ≤ 5), and generates bar charts of the most frequent sequences.

> **Note**: Because the Game of Life renderer calls `simPutPixel`, `simRand`, and other SIM functions thousands of times per second, the `call` instruction typically dominates the trace—this reflects real program behavior, not a bug.

## Requirements

- `clang` (20 or higher)
- `llvm-dev` (matching your Clang version)
- `libsdl2-dev`
- `cmake` (3.20 or higher)
- `python 3` with `matplotlib` (3.10 or higher)


## Building and Running

### Build the instrumented executable:
```bash
cd 01-LLVM-Pass
cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
cmake --build build
```

### Run the application and capture a trace (optional, should be stopped manually):
```bash
./build/game_of_life_instrumented > trace.log
```

### Analyze the trace (using venv recommended):
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install matplotlib

python3 analyze_ir_trace.py ./build/game_of_life_instrumented \
  --duration 3 \
  --top 5 \
  --output-dir ./results
```

## Project Structure

- `pass.cpp`: The LLVM pass implementation (module pass, runs after all optimizations).
- `logger.cpp`: Minimal `printInstr` implementation using `puts` (no LLVM runtime dependency).
- `analyze_ir_trace.py`: Python script for trace analysis and visualization.
- `CMakeLists.txt`: Configures selective instrumentation of `app.c` only.

## Sample results:

![Patterns of length 1](results/patterns_len_1.png)
![Patterns of length 2](results/patterns_len_2.png)
![Patterns of length 3](results/patterns_len_3.png)
![Patterns of length 4](results/patterns_len_4.png)
![Patterns of length 5](results/patterns_len_5.png)

## License

This project is distributed under the same permissive terms as LLVM and SDL2. The LLVM pass and analysis tools are free to use, modify, and distribute in any software project.
