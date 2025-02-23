#!/bin/sh
rm -rf build
cmake -DCMAKE_BUILD_TYPE=Debug -DHYPRMONITOR_NO_VERSION_CHECK=TRUE -B build
bear -- cmake --build build -j$(nproc)

