
{ system, pkgs, miniCompileCommands, hyprlandPkg, hyprland, gccVersion }:  
let
  mcc-env = (pkgs.callPackage miniCompileCommands {}).wrap gccVersion.stdenv; 
  mcc-hook = (pkgs.callPackage miniCompileCommands {}).hook;

  package = mcc-env.mkDerivation (self: {
    name = "hypr-monitor";
    version = "0.0.1";

    nativeBuildInputs = with pkgs; [
      mcc-hook
      pkg-config
      cmake
      gnumake
      clang
      gccVersion
      hyprlandPkg
    ] ++ hyprlandPkg.nativeBuildInputs;

    buildInputs = with pkgs; [
      fmt
      hyprlandPkg
    ] ++ hyprlandPkg.buildInputs;



    src = builtins.path {
      path = ./.;

      # Filter all files that begin with '.', for example '.git', that way
      # .git directory will not become part of the source of our package
      filter = path: type:
        !(pkgs.lib.hasPrefix "." (baseNameOf path));
    };

    # Specify cmake flags
    cmakeFlags = [
      "-DCMAKE_CXX_STANDARD=23"  # <-- Force C++23
      "--no-warn-unused-cli" # Supresses unused varibles warning
      "-DCMAKE_BUILD_TYPE=Debug"  # Force debug mode
    ];

    dontStrip = true;

    shellHook = ''
      export CXXFLAGS="-std=c++23"
      export LDFLAGS="-L${hyprlandPkg.libHyprland}/lib -lhyprland" # ✅ Ensure Hyprland is linked
      export LLDB_PATH=${pkgs.lldb_14}/bin/lldb-vscode
    '';
  });

  shell = pkgs.mkShell {
    inputsFrom = [ package ];
    packages = with pkgs; [
      hyprlandPkg
    ];

    shellHook = ''
      export CXXFLAGS="-std=c++23"
      export LLDB_PATH=${pkgs.lldb_14}/bin/lldb-vscode
    '';
  };
in
{
  package = package;
  shell = shell;
}

