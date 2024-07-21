{ pkgs, ... }:
let
  # FIXME: temporary palette until catppuccin/nix is included
  palette = {
    base = "24273a";
    text = "cad3f5";
    crust = "181926";
    surface2 = "5b6078";
  };
in {
  services.swaync = {
    enable = true;
    settings = {
      "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 4;
      control-center-margin-bottom = 4;
      control-center-margin-left = 4;
      control-center-margin-right = 4;
      widgets = [ "volume" "mpris" "title" "dnd" "notifications" ];
      widget-config = {
        dnd = { text = "Do not disturb"; };
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "󰆴";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
        volume = {
          label = "󰕾";
          show-per-app = true;
        };
      };
    };
    style = with palette; ''
      * {
        font-family: monospace;
        font-size: 16px;
        border-radius: 4px;
        color: #${text};
      }
      .control-center {
        background: alpha(#${base}, 0.8);
      }
      .widget-volume {
        background: transparent;
      }
      .widget-volume button {
        border: none;
        border-radius: 8px;
        background: transparent;
      }
      .widget-title {
        font-size: 24px;
      }
      .widget-title button {
        border: none;
        border-radius: 8px;
        background: transparent;
      }
      .notification {
        border: #${surface2} 2px solid;
        border-radius: 8px;
        background: alpha(#${crust}, 0.8);
        padding: 4px;
      }
      .close-button {
        border: none;
        border-radius: 8px;
        margin: 4px;
        background: #${surface2};
        color: #${surface2};
      }
    '';
  };
  wayland.windowManager.hyprland.settings.bind = [
    "$super, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t"
  ];
}
