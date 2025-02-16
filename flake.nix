{
  inputs.flake-utils.url = "github:numtide/flake-utils"; 
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/1128e89fd5e11bb25aedbfc287733c6502202ea9";

  inputs.miniCompileCommands = {
    url = "github:danielbarter/mini_compile_commands/v0.6";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, miniCompileCommands, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {};
        overlays = [];
      };
      pkgsOut = import ./default.nix {
        inherit system pkgs miniCompileCommands;
      };
    in {
      packages.default = pkgsOut.package; 
      devShells.default = pkgsOut.shell;
      formatter = pkgs.alejandra;
    });
}

