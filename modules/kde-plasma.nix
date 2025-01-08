{ lib, pkgs, config, ... }: {
  home.packages = with pkgs; [];

  dotfiles.links = [
    "konsolerc"
  ];

  xdg.dataFile."konsole" = config.dotfiles.linkDots "konsole";
}
