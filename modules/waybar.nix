{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        output = "DSI-1";
        height = 24;
        fixed-center = true;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
          "idle_inhibitor"
        ];

        modules-right = [
          "hyprland/language"
          "battery"
          "wireplumber"
          "tray"
        ];

        clock = {
          format = "{:%H:%M:%S}";
          interval = 1;
        };

        wireplumber = {
          format = "󰕾 {volume}%";
          format-muted = "󰸈";
          scroll-step = 5;
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
              activated = " ";
              deactivated = " ";
          };
          tooltip-format-activated = "NO SLEEP";
          tooltip-format-deactivated = "Sleep";
        };

        "hyprland/language" = {
          format-en = "EN";
          format-ru = "RU";
        };
      };
    };
    style = ''
      * {
        font-family: monospace;
        font-weight: 600;
        font-size: 14px;
        color: @theme_fg_color;
      }

      window#waybar {
        background: alpha(@theme_base_color, 0.8);
      }

      tooltip {
        background: alpha(@theme_base_color, 0.8);
      }

      #clock,
      #battery,
      #language,
      #wireplumber,
      #tray {
        padding: 0 10px;
        border: 0;
      }
      
      #workspaces button {
        padding: 0;
        margin: 0;
        font-size: 10px;
      }

      #idle_inhibitor {
        color: @theme_base_color;
        padding-left: 10px;
      }
    '';
  };
}
