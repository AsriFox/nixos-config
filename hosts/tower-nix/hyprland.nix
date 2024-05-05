{ pkgs, config, inputs, ... }: {
  imports = [ inputs.hyprland.homeManagerModules.default ];

  # modules/hyprland.nix
  hyprland = {
    enable = true;
    monitors =
      let wallpapersDir = "${config.home.homeDirectory}/Pictures/wallpapers";
      in [
        {
          name = "DP-1";
          offset = "0x0";
          workspaces = [ "1" "2" "3" "4" "5" "6" ];
          wallpaper = "${wallpapersDir}/kawakami_rokkaku_holo_bed_brush0.jpg";
        }
        {
          name = "DP-2";
          offset = "2560x480";
          workspaces = [ "7" "8" "9" ];
          wallpaper = "${wallpapersDir}/1372775.png";
        }
      ];
  };

  # modules/hypridle.nix
  hypridle = {
    enable = true;
    hyprctl =
      "${inputs.hyprland.packages.${pkgs.system}.hyprland.outPath}/bin/hyprctl";
    lockCmd = "${pkgs.swaylock-effects.outPath}/bin/swaylock";
    # lockCmd = "${
    #     inputs.hyprlock.packages.${pkgs.system}.hyprlock.outPath
    #   }/bin/hyprlock";
  };

  # modules/hyprlock.nix
  # https://github.com/hyprwm/Hyprland/issues/5816
  # hyprlock = {
  #   enable = true;
  #   promptMonitors = [ "DP-1" ];
  # };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      bs-hl-color = "f4dbd6";
      caps-lock-bs-hl-color = "f4dbd6";
      caps-lock-key-hl-color = "a6da95";
      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";
      key-hl-color = "a6da95";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "cad3f5";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "b7bdf8";
      ring-clear-color = "f4dbd6";
      ring-caps-lock-color = "f5a97f";
      ring-ver-color = "8aadf4";
      ring-wrong-color = "ee99a0";
      separator-color = "00000000";
      text-color = "cad3f5";
      text-clear-color = "f4dbd6";
      text-caps-lock-color = "f5a97f";
      text-ver-color = "8aadf4";
      text-wrong-color = "ee99a0";
      screenshots = true;
      clock = true;
      effect-blur = "7x5";
      fade-in = 3;
    };
  };
}
