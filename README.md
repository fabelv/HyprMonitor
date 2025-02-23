# HyprMonitor

HyprMonitor is a **Hyprland plugin** for managing monitor configurations dynamically. It allows users to define **monitor profiles** and switch between them seamlessly.

## Features
- **Monitor Profile Management**: Define different monitor layouts for home, work, or cafés.
- **Auto-Detect Configurations**: Reads settings from the Hyprland configuration.

---

## Installation & Usage

### 1. **Set Up the Development Environment**
First, enter the Nix development shell:
```sh
nix develop
```
This ensures that all necessary dependencies are available.

### 2. **Building the Plugin**
You can build the plugin using Nix:
```sh
nix build .#hypr-monitor
```
Alternatively, build using CMake and Ninja:
```sh
./compile_commands_bear.sh
```

### 3. **Installing the Plugin**
After building, copy the plugin to the Hyprland plugins directory:
```sh
cp build/libhypr-monitor.so ~/.local/share/hyprland/plugins/
```

### 4. **Loading the Plugin**
To load the plugin into Hyprland, run:
```sh
hyprctl plugin load ~/.local/share/hyprland/plugins/libhypr-monitor.so
```

### 5. **Configuring HyprMonitor**
Add your monitor configurations in `hyprland.conf`:
```ini
plugin = {
  HyprMonitor = {
    home_pc = DP-2,3440x1440,0x0,1;
    work = DP-3,3440x1440,0x0,1; DP-4,1920x1080,3440x0,1;
    cafe = eDP-1,1920x1080,0x0,1;
  }
}
```
Reload Hyprland:
```sh
hyprctl reload
```
---

## Project Structure
This repository is structured as follows:
```
HyprMonitor/
├── CMakeLists.txt               # CMake build configuration
├── default.nix                   # Nix package derivation
├── flake.nix                      # Nix flake for dependency management
├── shell.nix                      # Development environment setup
├── hyprpm.toml                   # Plugin package manager configuration
├── compile_commands_bear.sh  # Script to generate compile_commands.json with bear
├── compile_commands_cmake.sh # Script to generate compile_commands.json with CMake
├── src/                          # Source code directory
│   ├── main.cpp                  # Plugin main file
│   ├── ...
└── build/                        # Compiled output (generated)
```

---

## Explanation of Each File

### **Build & Configuration Files**
- **CMakeLists.txt** → Defines the CMake build process for compiling the plugin.
- **default.nix** → Nix package derivation that builds the plugin using `hyprland.dev` dependencies.
- **flake.nix** → Defines a Nix flake that manages dependencies and build environments.
- **shell.nix** → Provides a development shell with all required tools.

### **Build Scripts**
- **compile_commands_bear.sh** → Uses `bear` to generate `compile_commands.json` for IDE support.
- **compile_commands_cmake.sh** → Generates `compile_commands.json` using CMake.

### **Plugin Management**
- **hyprpm.toml** → Defines plugin metadata for Hyprland package management.

### **Source Code**
- **src/** → Contains all C++ source files for the plugin.
- **src/main.cpp** → Entry point for the plugin.

### **Generated Files**
- **build/** → Output directory for compiled binaries (ignored in Git).

---

## Development & Debugging

### **Rebuilding & Reloading the Plugin**
```sh
nix develop
nix build .#hypr-monitor
cp build/libhypr-monitor.so ~/.local/share/hyprland/plugins/
hyprctl plugin load ~/.local/share/hyprland/plugins/libhypr-monitor.so
```

### **Checking Plugin Logs**
```sh
journalctl -xe | grep Hyprland
hyprctl logs
```

### **Unloading the Plugin**
```sh
hyprctl plugin unload HyprMonitor
```

### **Disabling Version Checks**
For development, disable strict version checks:
```sh
nix build .#hypr-monitor --arg versionCheck false
```

---

## License
This project is licensed under the **GPL-3.0 License**.

---

## Author
**Fabio Elvedi**

---

## Contributing
Feel free to open an issue or PR for improvements!

