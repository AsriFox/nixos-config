{ lib, config, inputs, ... }:
let
  cfg = config.catppuccin;
  catppuccin-qt5ct = builtins.fetchGit {
    url = "https://github.com/catppuccin/qt5ct";
    rev = "89ee948e72386b816c7dad72099855fb0d46d41e";
  };
  flavour' = let fl = cfg.flavour;
  in with builtins;
  lib.toUpper (substring 0 1 fl) + (substring 1 ((stringLength fl) - 1) fl);
  qtctConf = "${catppuccin-qt5ct}/themes/Catppuccin-${flavour'}.conf";
in {
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  config = lib.mkIf cfg.enable {
    programs.fish.catppuccin = with cfg; { inherit enable flavour; };

    programs.bat.catppuccin = with cfg; { inherit enable flavour; };

    programs.lazygit.catppuccin = with cfg; {
      inherit enable flavour;
      accent = "lavender";
    };

    programs.kitty.catppuccin = with cfg; { inherit enable flavour; };

    programs.starship.catppuccin = with cfg; { inherit enable flavour; };

    qt = {
      enable = true;
      platformTheme = "qtct";
    };
    xdg.configFile."qt5ct/colors/Catppuccin-${flavour'}.conf".source = qtctConf;
    xdg.configFile."qt6ct/colors/Catppuccin-${flavour'}.conf".source = qtctConf;
    # TODO: qt5ct module?
    # xdg.configFile."qt5ct/qt5ct.conf".text = ''
    #   custom_palette=true
    #   color_scheme_path=/home/asrifox/.config/qt5ct/colors/Catppuccin-${flavour}.conf
    # '';
  };
}
