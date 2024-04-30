{ pkgs, inputs, ... }: {
  imports = [ inputs.hyprland.homeManagerModules.default ];

  # Common configuration; see modules/hyprland.nix
  hyprland = {
    enable = true;
    monitors = [{
      name = "DSI-1";
      scale = 2;
      extra = [ "transform,3" ];
      workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      wallpaper = "/home/asrifox/Pictures/Wallpapers/1596796944195584330.jpg";
    }];
  };

  # Touchscreen
  wayland.windowManager.hyprland = {
    plugins = with inputs; [ hyprgrass.packages.${pkgs.system}.default ];
    settings = {
      device = [{
        name = "goodix-capacitive-touchscreen-1";
        transform = "3";
      }];
      gestures = {
        workspace_swipe = true;
        workspace_swipe_touch = true;
        workspace_swipe_cancel_ratio = 0.15;
      };
      plugin = {
        touch_gestures = {
          sensitivity = 4.0;
          workspace_swipe_edge = "false";
        };
      };
    };
  };
}
