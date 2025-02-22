
{ pkgs, hyprlandPkg }:

pkgs.stdenv.mkDerivation rec {
  pname = "hypr-monitor";
  version = "0.1";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    hyprlandPkg
  ] ++ hyprlandPkg.nativeBuildInputs;

  buildInputs = with pkgs; [
    fmt
    hyprlandPkg
    libdrm
    libinput
    pango
    pixman
    wayland
  ] ++ hyprlandPkg.buildInputs;

  installPhase = ''
    mkdir -p $out/lib/hyprland/plugins
    cp libhypr-monitor-plugin.so $out/lib/hyprland/plugins/
  '';
}

