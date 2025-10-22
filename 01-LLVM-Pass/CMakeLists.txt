cmake_minimum_required(VERSION 3.20)
project(Pass LANGUAGES C CXX)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Using LLVM ${LLVM_PACKAGE_VERSION}")
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_llvm_pass_plugin(pass src/pass.cpp)

set(PASS-PLUGIN-NAME "pass.so")  
set(PASS-PLUGIN-PATH "${CMAKE_CURRENT_BINARY_DIR}/${PASS-PLUGIN-NAME}")

set(SDL-DIR ${CMAKE_CURRENT_SOURCE_DIR}/../00-SDL)

set(GUI-app-include-dir ${SDL-DIR}/include)
set(GUI-lib-sources      ${SDL-DIR}/lib/GUI-lib.c)
set(GUI-app-start-source ${SDL-DIR}/src/start.c)
set(GUI-one-cycle-app-IR ${SDL-DIR}/IR/one-cycle-app.ll)

if(NOT EXISTS ${GUI-one-cycle-app-IR})
  message(FATAL_ERROR "Input IR not found: ${GUI-one-cycle-app-IR}. Please build 00-SDL first.")
endif()

set(GUI-logged-app-IR ${CMAKE_CURRENT_BINARY_DIR}/logged-one-cycle-app.ll)

add_custom_command(
  OUTPUT ${GUI-logged-app-IR}
  DEPENDS pass ${GUI-one-cycle-app-IR}
  COMMAND "${LLVM_TOOLS_BINARY_DIR}/opt"
          -load-pass-plugin=${PASS-PLUGIN-PATH}
          -passes=my-pass
          -S
          "${GUI-one-cycle-app-IR}"
          -o "${GUI-logged-app-IR}"
  COMMENT "Generate LLVM IR for logged one cycle app"
  VERBATIM
)

add_custom_target(GUI-logged-app-IR-target ALL DEPENDS ${GUI-logged-app-IR})

find_program(SDL2_CONFIG sdl2-config REQUIRED)
execute_process(
  COMMAND ${SDL2_CONFIG} --libs
  OUTPUT_VARIABLE SDL2_LINK_FLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(log-sources ${CMAKE_CURRENT_SOURCE_DIR}/src/logger.c)
set(GUI-logged-app-exe ${CMAKE_CURRENT_BINARY_DIR}/gui-logged-app)

add_custom_command(
  OUTPUT "${GUI-logged-app-exe}"
  DEPENDS ${GUI-app-start-source}
          ${GUI-lib-sources}
          ${log-sources}
          ${GUI-logged-app-IR}
          GUI-logged-app-IR-target
  COMMAND clang
          -O3 -std=c23
          "${GUI-app-start-source}"
          "${GUI-lib-sources}"
          "${log-sources}"
          "${GUI-logged-app-IR}"
          -I "${GUI-app-include-dir}"
          ${SDL2_LINK_FLAGS}
          -o "${GUI-logged-app-exe}"
  COMMENT "Generate logged one cycle app"
  VERBATIM
)

add_custom_target(GUI-logged-app-target ALL DEPENDS "${GUI-logged-app-exe}")