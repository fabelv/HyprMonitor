{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.hyprland.url = "github:hyprwm/Hyprland";

  outputs = { self, nixpkgs, flake-utils, hyprland, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      pkgs = import nixpkgs { inherit system; };
      hyprlandPkg = hyprland.packages.${system}.hyprland;
    in {
      packages.hypr-monitor = pkgs.callPackage ./default.nix { inherit pkgs hyprlandPkg; };

      devShells.default = pkgs.mkShell {
        inputsFrom = [ hyprlandPkg ];
        packages = with pkgs; [
          cmake
          ninja
          pkg-config
          hyprlandPkg
        ];
      };
    });
}

