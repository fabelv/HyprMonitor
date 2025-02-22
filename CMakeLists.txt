
cmake_minimum_required(VERSION 3.27)

project(hypr-monitor-plugin
  VERSION 0.1
  DESCRIPTION "Hyprland monitor tool plugin"
  LANGUAGES CXX
)

# Set C++23 and build settings.
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")

# Find fmt library.
find_package(fmt REQUIRED)

# Find Hyprland and related dependencies via pkg-config.
find_package(PkgConfig REQUIRED)
pkg_check_modules(DEPS REQUIRED IMPORTED_TARGET
    hyprland
    libdrm
    libinput
    libudev
    pangocairo
    pixman-1
    wayland-server
    xkbcommon
)

# Gather all source files (adjust the pattern if necessary).
file(GLOB_RECURSE SOURCES "src/*.cpp")

# Build as a shared library (plugin).
add_library(hypr-monitor-plugin SHARED ${SOURCES})

# Add include directories from dependencies.
target_include_directories(hypr-monitor-plugin PRIVATE ${DEPS_INCLUDE_DIRS})

# Link against fmt and the combined Hyprland dependencies.
target_link_libraries(hypr-monitor-plugin PRIVATE fmt::fmt PkgConfig::DEPS)

# Install the plugin to the location where Hyprland expects plugins.
install(TARGETS hypr-monitor-plugin DESTINATION lib/hyprland/plugins)

