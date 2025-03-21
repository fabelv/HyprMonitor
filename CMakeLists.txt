
cmake_minimum_required(VERSION 3.19)

project(HyprMonitor VERSION "0.1")
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_compile_definitions(WLR_USE_UNSTABLE)
add_compile_options(-Wall -Wextra -Wno-unused-parameter -Wno-unused-value -Wno-missing-field-initializers -Wno-narrowing -Wno-pointer-arith)

# Ensure correct include paths when generating compile_commands.json
if(CMAKE_EXPORT_COMPILE_COMMANDS)
    set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES
        ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()

# Find dependencies using pkg-config
find_package(PkgConfig REQUIRED)
pkg_check_modules(DEPS REQUIRED hyprland pixman-1 libdrm pango pangocairo libinput wayland-client xkbcommon)

# Define the shared library (Add source files if needed)
add_library(hypr-monitor SHARED
    src/main.cpp
    src/config
)

# Allow disabling version check for easier debugging
option(HYPRMONITOR_NO_VERSION_CHECK "Disable Hyprland version check" FALSE)

if (HYPRMONITOR_NO_VERSION_CHECK)
    target_compile_definitions(hypr-monitor PRIVATE -DHYPRMONITOR_NO_VERSION_CHECK=TRUE)
endif()

# Include directories for dependencies
target_include_directories(hypr-monitor PRIVATE ${DEPS_INCLUDE_DIRS})

# Link libraries for dependencies
target_link_libraries(hypr-monitor PRIVATE ${DEPS_LIBRARIES})

# Install the compiled shared library
install(TARGETS hypr-monitor LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

