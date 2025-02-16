
{ system, pkgs, miniCompileCommands, hyprlandPkg, gccVersion }:  
let
  mcc-env = (pkgs.callPackage miniCompileCommands {}).wrap gccVersion.stdenv; 
  mcc-hook = (pkgs.callPackage miniCompileCommands {}).hook;

  package = mcc-env.mkDerivation (self: {
    name = "hypr-monitor";
    version = "0.0.1";

    nativeBuildInputs = with pkgs; [
      mcc-hook
      ncurses
      cmake
      gnumake
      clang
      gccVersion
      vscode-extensions.vadimcn.vscode-lldb
      lldb_14
      hyprlandPkg
    ];

    buildInputs = with pkgs; [
      fmt
      hyprlandPkg
    ];

    src = builtins.path {
      path = ./.;
      filter = path: type: !(pkgs.lib.hasPrefix "." (baseNameOf path));
    };

    cmakeFlags = [
      "--no-warn-unused-cli"
      "-DCMAKE_BUILD_TYPE=Debug"
    ];

    dontStrip = true;
  });

  shell = pkgs.mkShell {
    inputsFrom = [ package ];
    packages = with pkgs; [ hyprlandPkg ];
    shellHook = ''
      export LLDB_PATH=${pkgs.lldb_14}/bin/lldb-vscode
    '';
  };
in
{
  package = package;
  shell = shell;
}

