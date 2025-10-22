# LLVM IR Instruction Tracer

This project implements an **instrumenting LLVM pass** that dynamically traces the execution of LLVM IR instructions in the `one-cycle-app.c` module of the **Rule 110 cellular automaton** (from `../00-SDL`). The pass collects a runtime trace of instruction opcodes and enables statistical analysis of frequently occurring instruction patterns of length 1 to 5.

The instrumentation is applied **only to the core automaton logic (`one-cycle-app.c`)**, while SDL2 rendering and the main event loop remain unmodified—ensuring focused and efficient analysis of the computational core.

## Features

- **Selective Instrumentation**: Only `one-cycle-app.c` (containing `app()`, `apply_rule()`, and `set_bound_cond()`) is instrumented.
- **Dual Logging API**:  
  - `optLogger("opcode")` for general IR instructions (`add`, `load`, `br`, etc.)  
  - `callOptLogger("caller", "callee")` for function calls (e.g., `app → gui_rand`)
- **PHI-Node Exclusion**: Skips `phi` instructions, as they are SSA artifacts and not executed at runtime.
- **Runtime JSON Trace**: All events are written to `runtime.json` for offline analysis.

## How It Works

1. The LLVM pass inserts calls to `optLogger` and `callOptLogger` before every relevant IR instruction in the automaton functions.
2. When the instrumented binary runs, these loggers write structured trace entries to `runtime.json`.
3. The trace captures the **exact sequence of low-level operations** that implement Rule 110’s logic, including:
   - Bitwise operations (`and`, `or`, `lshr`)
   - Memory accesses (`load`, `store`, `getelementptr`)
   - Control flow (`br`, `icmp`)
   - External calls (`gui_rand`, `gui_set_pixel`, `gui_flush`)

## Requirements

- `clang` and `llvm` (17 recommended)
- `libsdl2-dev` (for linking the GUI runtime)
- `cmake` (3.20 or higher)
- `sdl2-config` (usually included with `libsdl2-dev`)


## Building and Running

### Step 1: Build the base IR (from `00-SDL`)

### Step 2: Build the instrumented executable
```bash
mkdir build && cd build
cmake .. -DCMAKE_C_COMPILER=clang-17
cmake --build .
```

### Step 3: Run the application
```bash
./gui-logged-app
```
The program will create `runtime.json` in the current directory.

## Project Structure

- `src/pass.cpp`: LLVM module pass that injects logging calls.
- `src/logger.c`: Runtime implementation of `optLogger` and `callOptLogger` (writes to `runtime.json`).
- `CMakeLists.txt`: Coordinates IR instrumentation and linking with SDL2.

## Sample Trace Snippet (`runtime.json`)

```json
["alloca",
"call app->llvm.lifetime.start.p0",
"call app->llvm.memset.p0.i64",
"br",
"call app->gui_rand",
"trunc",
"and",
"getelementptr",
"store",
"add",
"icmp",
"br",
"call app->gui_rand",
"trunc",
"and",
"getelementptr",
"store",
...
""]
```

### Analyzing the Instruction Trace

After running the instrumented application (which generates `../build/runtime.json`), you can analyze the trace and visualize frequent instruction patterns:

```bash
python3 analyze_ir_trace.py --top 5 --output-dir ../res
```

This command:
- Reads the trace from the default location `../build/runtime.json`
- Analyzes instruction sequences of lengths 1 through 5
- Saves the top 5 most frequent patterns for each length as bar charts in `../res/`

> Make sure `matplotlib` is installed, at least in `venv`:
> ```bash
> pip install matplotlib
> ```

The output will include files like:
```
../res/patterns_len_1.png
../res/patterns_len_2.png
...
../res/patterns_len_5.png
```

## License

This project is distributed under the same permissive terms as **SDL2**.  
The LLVM pass and logger are free to use, modify, and distribute in any software project.  
SDL2 is licensed under the [zlib license](https://www.libsdl.org/license.php).