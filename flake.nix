
{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  # Ensure `systems` is included, as Hyprland depends on it
  inputs.systems.url = "github:nix-systems/default";

  # Use Hyprland as an input
  inputs.hyprland = {
    url = "github:hyprwm/Hyprland";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.systems.follows = "systems";
  };

  inputs.miniCompileCommands = {
    url = "github:danielbarter/mini_compile_commands/v0.6";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, systems, hyprland, miniCompileCommands, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues hyprland.overlays;
      };

      hyprlandPkg = hyprland.packages.${system}.hyprland;

      # Force GCC 13.3.0 instead of GCC 14
      gccVersion = pkgs.gcc13;

      pkgsOut = import ./default.nix {
        inherit system pkgs miniCompileCommands hyprlandPkg gccVersion;
      };
    in {
      packages.default = pkgsOut.package;
      devShells.default = pkgsOut.shell;
      formatter = pkgs.alejandra;
    });
}

