{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "tower-nix";
}
