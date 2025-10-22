cmake_minimum_required(VERSION 3.20)
project(GUI-App C)

find_package(SDL2 REQUIRED CONFIG)

set(GUI-lib-sources ${CMAKE_SOURCE_DIR}/lib/GUI-lib.c)
set(GUI-one-cycle-app-source ${CMAKE_SOURCE_DIR}/src/one-cycle-app.c)
set(GUI-app-source ${CMAKE_SOURCE_DIR}/src/app.c)
set(GUI-app-start-source ${CMAKE_SOURCE_DIR}/src/start.c)
set(GUI-app-include-dir ${CMAKE_SOURCE_DIR}/include)

file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/IR)

add_library(GUI-lib STATIC ${GUI-lib-sources})
target_include_directories(GUI-lib PUBLIC ${GUI-app-include-dir})
target_link_libraries(GUI-lib PRIVATE SDL2::SDL2)

add_executable(GUI-app ${GUI-app-source} ${GUI-app-start-source})
target_include_directories(GUI-app PRIVATE ${GUI-app-include-dir})
target_link_libraries(GUI-app PRIVATE GUI-lib)

set(GUI-app-IR ${CMAKE_SOURCE_DIR}/IR/app.ll)
add_custom_command(
    OUTPUT ${GUI-app-IR}
    DEPENDS ${GUI-app-source} ${GUI-app-include-dir}
    COMMAND ${CMAKE_C_COMPILER}
            -O3 -std=c23 -emit-llvm -S
            ${GUI-app-source}
            -I ${GUI-app-include-dir}
            -o ${GUI-app-IR}
    COMMENT "Generate LLVM IR for app"
    VERBATIM
)
add_custom_target(GUI-app-IR-target ALL DEPENDS ${GUI-app-IR})

set(GUI-one-cycle-app-IR ${CMAKE_SOURCE_DIR}/IR/one-cycle-app.ll)
add_custom_command(
    OUTPUT ${GUI-one-cycle-app-IR}
    DEPENDS ${GUI-one-cycle-app-source} ${GUI-app-include-dir}
    COMMAND ${CMAKE_C_COMPILER}
            -O3 -std=c23 -emit-llvm -S
            ${GUI-one-cycle-app-source}
            -I ${GUI-app-include-dir}
            -o ${GUI-one-cycle-app-IR}
    COMMENT "Generate LLVM IR for one cycle app"
    VERBATIM
)
add_custom_target(GUI-one-cycle-app-IR-target ALL DEPENDS ${GUI-one-cycle-app-IR})