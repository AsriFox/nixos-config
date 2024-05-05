{ pkgs, inputs, ... }: {
  imports = [ inputs.ags.homeManagerModules.default ];
  home.packages = with pkgs; [ bun dart-sass ];
  programs.ags = {
    enable = true;
    # configDir = ../ags;
  };
  # xdg.configFile."ags".src = ../ags;
}
