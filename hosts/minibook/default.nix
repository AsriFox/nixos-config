{ lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./hardware-quirks.nix
  ];

  networking.hostName = "minibook";

  services.displayManager.sddm.theme =
    let background = /home/asrifox/Pictures/Wallpapers/1596796944195584330.jpg;
    in "${import ../../modules/sddm-theme.nix { inherit pkgs background; }}";

  # https://search.nixos.org/options?query=stateVersion&show=system.stateVersion
  system.stateVersion = "23.11";
}
