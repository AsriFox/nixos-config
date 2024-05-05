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
    programs.powermenu =
      "wlogout -p layer-shell -b 5 -c 10 -L 720 -R 720 -T 600 -B 600";
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
      screenshots = true;
      clock = true;
      effect-blur = "7x5";
      fade-in = 3;
    };
  };
}
