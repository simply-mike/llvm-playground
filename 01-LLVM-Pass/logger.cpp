#include <cstdio>

extern "C" void printInstr(const char* name) {
    std::puts(name);
}