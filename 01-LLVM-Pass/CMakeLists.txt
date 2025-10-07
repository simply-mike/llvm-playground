cmake_minimum_required(VERSION 3.20)
project(GameOfLifeInstrumented LANGUAGES C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti -fno-exceptions")

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "LLVM include dirs: ${LLVM_INCLUDE_DIRS}")

find_package(PkgConfig REQUIRED)
pkg_check_modules(SDL2 REQUIRED sdl2)
include_directories(${SDL2_INCLUDE_DIRS})
link_directories(${SDL2_LIBRARY_DIRS})

set(SDL_APP_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../00-SDL)

add_library(instr_tracer_pass SHARED pass.cpp)
target_include_directories(instr_tracer_pass PRIVATE ${LLVM_INCLUDE_DIRS})

add_library(app_logic_instrumented OBJECT ${SDL_APP_DIR}/app.c)
target_compile_options(app_logic_instrumented PRIVATE
    -fpass-plugin=$<TARGET_FILE:instr_tracer_pass>
    -g
    -O2
)
target_include_directories(app_logic_instrumented PUBLIC ${SDL_APP_DIR})

add_library(rest_of_app OBJECT
    ${SDL_APP_DIR}/start.c
    ${SDL_APP_DIR}/sim.c
)
target_include_directories(rest_of_app PUBLIC ${SDL_APP_DIR})

add_executable(game_of_life_instrumented logger.cpp)
target_link_libraries(game_of_life_instrumented
    PRIVATE
        app_logic_instrumented
        rest_of_app
        ${SDL2_LIBRARIES}
)

if(NOT CMAKE_C_COMPILER MATCHES "clang")
    message(WARNING "Clang is recommended for -fpass-plugin support.")
endif()