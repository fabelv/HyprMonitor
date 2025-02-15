{
  inputs.flake-utils.url = "github:numtide/flake-utils"; 
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.miniCompileCommands = {
    url = "github:danielbarter/mini_compile_commands/v0.6";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, miniCompileCommands, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      pkgs = import nixpkgs { inherit system; };
      package = import ./default.nix {
        inherit system pkgs;
      };
    in {
      packages.default = package;
      devShells.default = package.shell;
      formatter = pkgs.alejandra;
    });
}

