cmake_minimum_required(VERSION 3.29)
project(hypr-monitor)

find_package(fmt REQUIRED)

set(CMAKE_CXX_STANDARD 23)
add_subdirectory(src)
install(TARGETS hypr-monitor DESTINATION bin)

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_FLAGS "-g -O0")  # Add debug symbols, disable optimizations
