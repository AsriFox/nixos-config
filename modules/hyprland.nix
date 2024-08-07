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
  monitorConf = { name, mode, offset, scale, extra, ... }:
    let extras = lib.concatStringsSep "," extra;
    in "${name}, ${mode}, ${offset}, ${builtins.toString scale}, ${extras}";
  kwallet-init = builtins.concatStringsSep " && " [
    "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
    "${pkgs.kdePackages.kwallet}/bin/kwallet-query --list-entries --folder 'Network Management' kdewallet"
    "${pkgs.networkmanagerapplet}/bin/nm-applet"
  ];
  cfg = config.hyprland;
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
          offset = mkOption {
            type = str;
            default = "auto";
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
          bar = mkOption {
            type = str;
            default = "waybar";
          };
          launcher = mkOption {
            type = str;
            default = "anyrun";
          };
          clipboard-menu = mkOption {
            type = str;
            default =
              "anyrun -c ~/.config/anyrun/cliphist | cliphist decode | wl-copy";
          };
          powermenu = mkOption {
            type = str;
            default = "wlogout -p layer-shell -b 5 -c 10";
          };
        };
      };
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
      hyprshot
      kdePackages.kwallet
      kdePackages.kwallet-pam
      networkmanagerapplet
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        env = [ "QT_QPA_PLATFORMTHEME,qt5ct" "XDG_MENU_PREFIX,plasma-" ];

        monitor = (map monitorConf cfg.monitors) ++ [ ", preferred, auto, 1" ];

        workspace = concatMap
          ({ name, workspaces, ... }: map (w: "${w}, monitor:${name}") workspaces)
          cfg.monitors;

        windowrule = [ "float, ^(.*polkit.*)$" ];
        windowrulev2 = [
          "idleinhibit fullscreen, class:(.+)"
          "float, class:(firefox), title:(Picture-in-Picture)"
          "dimaround, class:^(jetbrains-*)$"
        ];
        layerrule = [ "blur, waybar" ];

        exec-once = [
          "hyprpaper"
          kwallet-init
        ] ++ (with cfg.programs; [
          polkit
          bar
        ]);

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
        ] ++ (with cfg.programs; [
          "$super, T, exec, ${term}"
          "$super, E, exec, ${files}"
          "$super, B, exec, ${web}"
          "$super, Escape, exec, ${powermenu}"
        ]) ++ (with defaultPrograms; [
          ", Print, exec, ${screenshot.region}"
          "ALT, Print, exec, ${screenshot.window}"
          "SHIFT, Print, exec, ${screenshot.monitor}"
        ]) ++ (builtins.concatMap (n: [
          "$super, ${n}, workspace, ${n}"
          "$super SHIFT, ${n}, movetoworkspace, ${n}"
        ]) (builtins.concatLists
          (map ({ workspaces, ... }: workspaces) cfg.monitors)));
        bindr = [ "SUPER, SUPER_L, exec, ${cfg.programs.launcher}" ];
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindm =
          [ "$super, mouse:272, movewindow" "$super, mouse:273, resizewindow" ];
      };
    };

    xdg.configFile."hypr/hyprpaper.conf".text = builtins.concatStringsSep "\n"
      (builtins.concatMap ({ name, wallpaper, ... }: [
        "preload = ${wallpaper}"
        "wallpaper = ${name}, ${wallpaper}"
      ]) cfg.monitors);
  };
}
