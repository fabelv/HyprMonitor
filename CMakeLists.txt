cmake_minimum_required(VERSION 3.27)

project(hypr-monitor-plugin
  VERSION 0.1
  DESCRIPTION "Hyprland monitor tool plugin"
  LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE SRC "src/*.cpp")

add_library(hypr-monitor-plugin SHARED ${SRC})

find_package(PkgConfig REQUIRED)
pkg_check_modules(deps REQUIRED IMPORTED_TARGET
    hyprland
    libdrm
    libinput
    libudev
    pangocairo
    pixman-1
    wayland-server
    xkbcommon
)

target_link_libraries(hypr-monitor-plugin PRIVATE rt PkgConfig::deps)

install(TARGETS hypr-monitor-plugin DESTINATION ~/.local/share/hyprland/plugins)

