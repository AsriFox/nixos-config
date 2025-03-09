{ lib, config, pkgs, ... }:
# See also https://github.com/NixOS/nixos-hardware
let
  oldKernel = lib.versionOlder config.boot.kernelPackages.kernel.version "6.8";
in {
  # Use 16x32 font on HiDPI display
  console.font = lib.mkIf oldKernel (lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz");
  console.earlySetup = lib.mkIf oldKernel (lib.mkDefault true);

  boot.kernelParams = [
    "fbcon=rotate:1"
    "video=DSI-1:panel_orientation=right_side_up"
  ];

  # Rotate it like it's Steam Deck
  boot.loader.systemd-boot.consoleMode = "5";
}
