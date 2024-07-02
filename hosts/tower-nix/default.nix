{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "tower-nix";

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
}
