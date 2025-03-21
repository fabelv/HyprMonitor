{
  hyprland,
  lib,
  nix-gitignore,
  keepDebugInfo,
  stdenv ? (keepDebugInfo hyprland.stdenv),
  cmake,
  ninja,
  pkg-config,
  pango,
  cairo,
  nlohmann_json,
  debug ? false,
  hlversion ? "git",
  versionCheck ? true,
}: hyprland.stdenv.mkDerivation {
  pname = "hypr-monitor";
  version = "hl${hlversion}${lib.optionalString debug "-debug"}";
  src = nix-gitignore.gitignoreSource [] ./.;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    hyprland.dev
    pango
    cairo
    nlohmann_json
  ] ++ hyprland.buildInputs;

  cmakeFlags = lib.optional (!versionCheck) "-DHYPRMONITOR_NO_VERSION_CHECK=ON";

  cmakeBuildType = if debug
                   then "Debug"
                   else "RelWithDebInfo";

  buildPhase = "ninjaBuildPhase";
  enableParallelBuilding = true;
  dontStrip = true;

  meta = with lib; {
    homepage = "https://github.com/fabelv/HyprMonitor";
    description = "Hyprland plugin for monitor management";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

