{ pkgs, ... }: {
  home.username = "asrifox";
  home.homeDirectory = "/home/asrifox";

  xdg.enable = true;
  programs.home-manager.enable = true;

  stateVersion = "23.11";
}
