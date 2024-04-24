{ pkgs, config, inputs, ... }:
{
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    # when adding wallpaper: "magick: No such file or directory"
    targets.kde.enable = false;
    # https://github.com/danth/stylix/issues/200
    image = "${config.home.homeDirectory}/Pictures/Wallpapers/1596796944195584330.jpg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        name = "FiraCode Nerd Font";
      };
    };
  };
}
