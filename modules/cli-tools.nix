{ lib, pkgs, config, ... }: {
  home.packages = with pkgs; [
    wl-clipboard
    helix
    nixfmt-rfc-style
    git
    fish
    fzf
    bat
    lazygit
    starship
    hyfetch
    bottom
  ];

  dotfiles.links = [
    "git"
    "fish"
    "bat"
    "lazygit"
    "starship.toml"
    "hyfetch.json"
    "bottom"
  ];

  home.sessionVariables = {
    XCURSOR_SIZE = 32;
    QT_QPA_PLATFORM = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  # services.cliphist.enable = true;
}
