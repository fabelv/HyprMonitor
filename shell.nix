{
  hyprland,
  pkgs,
  hlversion ? "git",
  hypr-monitor ? pkgs.callPackage ./default.nix {
    inherit hyprland hlversion;
    versionCheck = false;
  },
}: pkgs.mkShell.override {
  inherit (hypr-monitor) stdenv;
} {
  inputsFrom = [ hypr-monitor ];

  nativeBuildInputs = with pkgs; [
    clang-tools
    bear
  ];
}
