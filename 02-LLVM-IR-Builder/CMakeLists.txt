cmake_minimum_required(VERSION 3.20)
project(IR-builder LANGUAGES C CXX)

find_package(LLVM REQUIRED CONFIG)
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

find_package(SDL2 REQUIRED CONFIG)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SDL-DIR ${CMAKE_CURRENT_SOURCE_DIR}/../00-SDL)
set(GUI-LIB-SOURCE ${SDL-DIR}/lib/GUI-lib.c)
set(GUI-INCLUDE-DIR ${SDL-DIR}/include)

add_llvm_executable(IR_Gen
  src/IR-builder.cpp
  ${GUI-LIB-SOURCE}
)

target_include_directories(IR_Gen PRIVATE ${GUI-INCLUDE-DIR})

target_link_libraries(IR_Gen PRIVATE SDL2::SDL2)