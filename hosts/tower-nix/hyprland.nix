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
    lockCmd = "${
        inputs.hyprlock.packages.${pkgs.system}.hyprlock.outPath
      }/bin/hyprlock";
  };

  # modules/hyprlock.nix
  hyprlock = {
    enable = true;
    promptMonitors = [ "DP-1" ];
  };
}
