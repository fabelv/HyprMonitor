# HyprMonitor

## Plugin Configuration (plugin.HyprMonitor)

HyprMonitor lets you define multiple monitor setups and automatically apply the most suitable configuration based on the currently connected displays and their properties (like serial, make, or model).

This is especially useful for people who use Hyprland on different devices (e.g., laptop and desktop) or have multiple monitor arrangements (e.g., home, office, docked).

## Configuration Structure
```
plugin = {
  HyprMonitor = {
    monitors = {
      <name> = {
        serial = "<monitor-serial>";
        make = "<manufacturer>";
        model = "<model-name>";
      };
      ...
    };

    setups = {
      <setup-name> = {
        match = [ "<monitor-name>", ... ]; # List of monitors that must be connected
        config = [
          "monitor=...,...,...",           # One or more `hyprctl monitor` lines
          ...
        ];
      };
      ...
    };
  };
};
```

## Example
```
plugin = {
  HyprMonitor = {
    monitors = {
      ultrawide = {
        serial = "#ASO8/a/4npHd";
        make = "Ancor Communications Inc";
        model = "ROG PG348Q";
      };
      laptop = {
        serial = "#XYZ123456789";
        make = "Framework";
        model = "eDP-1";
      };
    };

    setups = {
      desktop = {
        match = [ "ultrawide" ];
        config = [
          "monitor=DP-2,3440x1440@100,0x0,1"
        ];
      };

      laptop_lid_open = {
        match = [ "laptop", "ultrawide" ];
        config = [
          "monitor=eDP-1,1920x1080@60,0x0,1",
          "monitor=DP-2,3440x1440@100,1920x0,1"
        ];
      };

      laptop_lid_closed = {
        match = [ "ultrawide" ];
        config = [
          "monitor=DP-2,3440x1440@100,0x0,1"
        ];
      };
    };
  };
};
```
