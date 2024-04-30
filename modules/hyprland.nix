{ lib, pkgs, config, ... }:
let
  defaultPrograms = {
    screenshot = rec {
      cmd = "hyprshot";
      window = "${cmd} -m window";
      monitor = "${cmd} -m output";
      region = "${cmd} -m region";
    };
  };
  monitorConf = { name, mode, scale, extra, ... }:
    let extras = lib.concatStringsSep "," extra;
    in "${name}, ${mode}, auto, ${builtins.toString scale}, ${extras}";
in with lib; {
  options.hyprland = with types; {
    enable = mkEnableOption "Hyprland config";
    monitors = mkOption {
      type = listOf (submodule {
        options = {
          name = mkOption { type = str; };
          mode = mkOption {
            type = str;
            default = "preferred";
          };
          scale = mkOption {
            type = either float int;
            default = 1;
          };
          extra = mkOption {
            type = listOf str;
            default = [ ];
          };
          workspaces = mkOption { type = listOf str; };
          wallpaper = mkOption { type = str; };
        };
      });
    };
    programs = mkOption {
      type = submodule {
        options = {
          term = mkOption {
            type = str;
            default = "kitty";
          };
          files = mkOption {
            type = str;
            default = "dolphin";
          };
          web = mkOption {
            type = str;
            default = "firefox";
          };
          polkit = mkOption {
            type = str;
            default =
              "${pkgs.polkit-kde-agent.outPath}/libexec/polkit-kde-authentication-agent-1";
          };
        };
      };
      default = { };
    };
  };

  config = mkIf config.hyprland.enable {
    home.packages = with pkgs; [ hyprpaper hyprshot ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        env = [ "QT_QPA_PLATFORMTHEME,qt5ct" ];

        monitor = (map monitorConf config.hyprland.monitors)
          ++ [ ", preferred, auto, 1" ];

        workspace = concatMap
          ({ name, workspaces, ... }: map (w: "${w}, ${name}") workspaces)
          config.hyprland.monitors;

        windowrule = [ "float, ^(.*polkit.*)$" ];
        windowrulev2 = [
          "idleinhibit fullscreen, class:(.+)"
          "float, class:(firefox), title:(Picture-in-Picture)"
          "dimaround, class:^(jetbrains-*)$"
        ];

        exec-once = [ config.hyprland.programs.polkit "hyprpaper" ];

        input = {
          kb_layout = "us,ru(typewriter)";
          kb_options = "grp:win_space_toggle";
          follow_mouse = 1;
        };

        general = {
          gaps_in = 4;
          gaps_out = 4;
          border_size = 2;
          layout = "dwindle";
        };

        decoration = {
          rounding = 4;

          blur = {
            enabled = true;
            size = 4;
            passes = 2;
          };

          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
        };

        animations = {
          enabled = "yes";
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };

        "$super" = "SUPER";
        bind = [
          "$super, Q, killactive,"
          "$super, P, togglefloating,"
          "$super SHIFT, P, pseudo,"
          "$super, J, togglesplit,"

          "$super, left, movefocus, l"
          "$super, right, movefocus, r"
          "$super, up, movefocus, u"
          "$super, down, movefocus, d"

          "$super CTRL, left, swapwindow, l"
          "$super CTRL, right, swapwindow, r"
          "$super CTRL, up, swapwindow, u"
          "$super CTRL, down, swapwindow, d"
        ] ++ (with config.hyprland.programs; [
          "$super, T, exec, ${term}"
          "$super, E, exec, ${files}"
          "$super, B, exec, ${web}"
        ]) ++ (with defaultPrograms; [
          ", Print, exec, ${screenshot.region}"
          "ALT, Print, exec, ${screenshot.window}"
          "SHIFT, Print, exec, ${screenshot.monitor}"
        ]) ++ (builtins.concatMap (n: [
          "$super, ${n}, workspace, ${n}"
          "$super SHIFT, ${n}, movetoworkspace, ${n}"
        ]) (builtins.concatLists
          (map ({ workspaces, ... }: workspaces) config.hyprland.monitors)));

        bindm =
          [ "$super, mouse:272, movewindow" "$super, mouse:273, resizewindow" ];
      };
    };

    xdg.configFile."hypr/hyprpaper.conf".text = builtins.concatStringsSep "\n"
      (builtins.concatMap ({ name, wallpaper, ... }: [
        "preload = ${wallpaper}"
        "wallpaper = ${name}, ${wallpaper}"
      ]) config.hyprland.monitors);
  };
}
