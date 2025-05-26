cmake_minimum_required(VERSION 3.14.2)
project(Ndk-Libs)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)

enable_language(ASM)

add_compile_options(-fcolor-diagnostics -fPIC -Wno-attributes)
add_definitions(-D_FILE_OFFSET_BITS=64)

find_program(CMAKE_STRIP NAMES ${CMAKE_STRIP} strip)
find_program(CMAKE_RANLIB NAMES ${CMAKE_RANLIB} ranlib)

set(CMAKE_DIR "${PROJECT_SOURCE_DIR}/cmake")
set(SRC_DIR "${PROJECT_SOURCE_DIR}/src")
set(OUT_DIR "${PROJECT_SOURCE_DIR}/out")

include(${CMAKE_DIR}/abseil.cmake)
include(${CMAKE_DIR}/brotli.cmake)
include(${CMAKE_DIR}/fmtlib.cmake)
include(${CMAKE_DIR}/lz4.cmake)
include(${CMAKE_DIR}/zstd.cmake)