{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "tower-nix";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession = {
      enable = true;
      args = [ "--prefer-output" "DP-1" ];
    };
  };
}
