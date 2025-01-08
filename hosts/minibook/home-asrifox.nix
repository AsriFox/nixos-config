{ pkgs, ... }: {
  home.username = "asrifox";
  home.homeDirectory = "/home/asrifox";
  home.stateVersion = "23.11";

  xdg.enable = true;
  programs.home-manager.enable = true;
}
