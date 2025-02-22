
{ pkgs, hyprlandPkg }:

pkgs.stdenv.mkDerivation rec {
  pname = "hypr-monitor";
  version = "0.1";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    pkg-config
  ] ++ hyprlandPkg.nativeBuildInputs;

  buildInputs = with pkgs; [
    fmt
    hyprlandPkg
  ] ++ hyprlandPkg.buildInputs;

  preConfigure = ''
    export HYPRLAND_DIR="${hyprlandPkg}"
    export PKG_CONFIG_PATH="${hyprlandPkg}/lib/pkgconfig:$PKG_CONFIG_PATH"
  '';

  configurePhase = ''
    cmake -B build -DCMAKE_BUILD_TYPE=Debug
  '';

  buildPhase = ''
    cmake --build build
  '';


  installPhase = ''
    mkdir -p $out/lib/hyprland/plugins
    cp build/libhypr-monitor-plugin.so $out/lib/hyprland/plugins/
  '';

}

