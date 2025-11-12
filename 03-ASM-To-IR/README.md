# ASM To IR Generator

This project implements a **custom ASM to LLVM IR translator** that converts a custom assembly language into LLVM IR, then **executes it at runtime via LLVM's JIT engine**. The project includes a complete instruction set architecture (ISA), an assembly parser, and a cellular automaton (Rule 110) implementation demonstrating the full compilation pipeline.

Unlike traditional compilers, this ASM2IR generator **programmatically constructs LLVM IR** from parsed assembly instructions using LLVM's C++ API. The generated IR is then JIT-compiled and executed in-process, with dynamic linking to SDL2-based GUI functions for real-time visualization.

## Features

- **Custom ISA**
- **Two-Stage Translation**: Assembly → Parser → IR Generator → JIT Execution
- **Emulation-Based IR Generation**: Uses external function calls for complex operations while generating direct IR for control flow
- **Register File Architecture**: Global 32-register file mapped to LLVM IR
- **JIT Execution**: Uses LLVM's `ExecutionEngine` to compile and run IR in-process
- **Native GUI Integration**: Dynamically links generated IR with SDL2 functions (`gui_init`, `gui_set_pixel`, `gui_flush`, `gui_quit_event`)
- **LLVM 17 Compatible**

## Instruction Set Architecture

The custom ISA includes:

### Arithmetic Operations (5)
- `addi r1 r2 r3` - `r1 = r2 + r3`
- `subi r1 r2 r3` - `r1 = r2 - r3`
- `muli r1 r2 r3` - `r1 = r2 * r3`
- `divi r1 r2 r3` - `r1 = r2 / r3`
- `remi r1 r2 r3` - `r1 = r2 % r3`

### Logical Operations (4)
- `andi r1 r2 r3` - `r1 = r2 & r3`
- `xori r1 r2 r3` - `r1 = r2 ^ r3`
- `shli r1 r2 r3` - `r1 = r2 << r3`
- `shri r1 r2 r3` - `r1 = r2 >> r3`

### Comparison Operations (4)
- `ilt r1 r2 r3` - `r1 = r2 < r3` (signed)
- `imet r1 r2 r3` - `r1 = r2 >= r3` (signed)
- `neq r1 r2 r3` - `r1 = r2 != r3`
- `select r1 r2 r3 r4` - `r1 = r2 ? r3 : r4`

### Memory Operations (7)
- `lea r1 r2 r3 imm` - `r1 = r2 + r3 * imm` (load effective address)
- `lbi r1 r2` - `r1 = *(uint8_t*)r2` (load byte)
- `lwi r1 r2` - `r1 = *(uint32_t*)r2` (load word)
- `ldi r1 r2` - `r1 = *(uint64_t*)r2` (load dword)
- `sbi r1 r2` - `*(uint8_t*)r1 = r2` (store byte)
- `swi r1 r2` - `*(uint32_t*)r1 = r2` (store word)
- `sdi r1 r2` - `*(uint64_t*)r1 = r2` (store dword)

### Control Flow (4)
- `br label` - `pc = label` (unconditional branch)
- `brif r1 label1 label2` - `pc = r1 ? label1 : label2` (conditional branch)
- `call label` - Call function at label
- `ret` - Return from function

### Stack Operations (4)
- `push r1` - `*(sp++) = r1` (push register)
- `pop r1` - `r1 = *(sp--)` (pop register)
- `push_regs` - `*(sp+=32) = x0...x31` (save all registers)
- `pop_regs` - `x0...x31 = *(sp-=32)` (restore all registers)

### Data Movement (2)
- `mov r1 r2` - `r1 = r2`
- `mov_imm r1 imm` - `r1 = imm`

### Memory Management (2)
- `cf r1` - `r1 = new bool[GUI_WIDTH * GUI_HEIGHT]` (create frame)
- `df r1` - `delete[] r1` (destroy frame)

### GUI Operations (4)
- `flush` - `gui_flush()` (update screen)
- `has_quit r1` - `r1 = gui_quit_event()` (check window close)
- `set_pixel r1 r2 r3` - `gui_set_pixel(r1, r2, r3)` (draw pixel)
- `rgb_reg r1 r2 r3 r4 imm` - `r1 = (r2<<24)|(r3<<16)|(r4<<8)|imm` (pack color)

### Special Operations (3)
- `rand r1` - `r1 = rand()` (random number)
- `dump_regs` - Print all register values (debug)
- `dump_mem r1 r2` - Print memory range `


## Requirements

- `libsdl2-dev`
- `clang` (17 recommended))
- `llvm-dev` (17 recommended)
- `cmake` (3.20 or higher)

## Building and Running

```bash
cd 03-ASM-To-IR
mkdir build && cd build
cmake .. -DCMAKE_C_COMPILER=clang-17 -DCMAKE_CXX_COMPILER=clang++-17
make -j$(nproc)
./AsmToIR ../asm/app.txt
```

If you have a different LLVM version by default and LLVM 17 is installed separately, the `cmake` step should specify the LLVM directory:

```bash
cmake .. \
  -DCMAKE_C_COMPILER=clang-17 \
  -DCMAKE_CXX_COMPILER=clang++-17 \
  -DLLVM_DIR=/usr/lib64/cmake/llvm17
```

The program will:
1. Parse the assembly file
2. Generate LLVM IR and print it to stdout
3. Verify the generated functions
4. Initialize the SDL2 window
5. JIT-compile and execute the IR
6. Display the cellular automaton in real-time
7. Exit when the window is closed

## Architecture

```
include/
├── Builder.h        - Main IR generator class
├── CPU.h            - Virtual CPU emulator and register file
├── Instructions.h   - Instruction definition and parsing
└── Instructions.def - Instruction table (macro-based definitions)
src/
├── Builder.cpp       - IR generation and JIT execution logic
└── Instructions.cpp  - Instruction parsing and lazy function resolution
asm/
└── app.txt          - Cellular automaton implementation in custom ASM

AsmToIRGen.cpp        - Main entry point
```

Relies on external dependencies:
- `../00-SDL/lib/GUI-lib.c` - SDL2 wrapper implementation
- `../00-SDL/include/GUI-lib.h` - GUI function declarations


## Known Limitations

- Uses **deprecated ExecutionEngine API** (removed in LLVM 18+)
- **Emulation-based IR** is less optimized than direct IR generation
- No optimization passes applied (raw IR from generator)
- Limited error reporting in assembly parser

## License

This project is distributed under the **zlib license**, the same as SDL2.  
See [libsdl.org](https://www.libsdl.org/) for license details.