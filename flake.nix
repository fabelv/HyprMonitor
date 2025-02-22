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

  outputs = { self, nixpkgs, flake-utils, systems, hyprland, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      hyprlandPkg = hyprland.packages.${system}.hyprland;
    in {
      packages.default = import ./default.nix { inherit pkgs hyprlandPkg; };
      devShells.default = pkgs.mkShell {
        buildInputs = [ hyprlandPkg ];
      };
      formatter = pkgs.alejandra;
    });
}

