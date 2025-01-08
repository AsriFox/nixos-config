{ pkgs, ... }: {
  home.username = "asrifox";
  home.homeDirectory = "/home/asrifox";

  xdg.enable = true;
  programs.home-manager.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  stateVersion = "23.11";
}
