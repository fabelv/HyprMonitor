{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.hyprland.url = "github:hyprwm/Hyprland/410da2e46fc44d93196cd902a070391a416cff01";

  outputs = { self, nixpkgs, flake-utils, hyprland, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      pkgs = import nixpkgs { inherit system; };
      hyprlandPkg = hyprland.packages.${system}.hyprland;
    in {
      packages.default = pkgs.callPackage ./default.nix { inherit pkgs hyprlandPkg; };

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

