{ pkgs, ... }: {
  home.username = "asrifox";
  home.homeDirectory = "/home/asrifox";
  home.stateVersion = "23.11";

  xdg.enable = true;
  programs.home-manager.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
