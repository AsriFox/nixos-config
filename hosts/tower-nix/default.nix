{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "tower-nix";

  services.displayManager.sddm.theme =
    let background = /home/asrifox/Pictures/wallpapers/kawakami_rokkaku_holo_snowyspring0.jpeg;
    in "${import ../../modules/sddm-theme.nix { inherit pkgs background; }}";

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession = {
      enable = true;
      args = [ "--prefer-output" "DP-1" ];
    };
  };

  # https://search.nixos.org/options?query=stateVersion&show=system.stateVersion
  system.stateVersion = "23.11";
}
