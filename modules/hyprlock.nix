{ lib, pkgs, config, inputs, ... }:
let
  # FIXME: temporary palette until catppuccin/nix is included
  palette = {
    base = "24273a";
    text = "cad3f5";
    lavender = "b7bdf8";
  };
  cfg = config.hyprlock;
in with lib; {
  options.hyprlock = with types; {
    enable = mkEnableOption "Hyprlock config";
    promptMonitors = mkOption {
      type = listOf str;
      default = [ ];
    };
  };

  config.programs.hyprlock = mkIf cfg.enable {
    enable = true;
    settings = {
      background = [{
        path = "screenshot";
        blur_size = 4;
        blur_passes = 2;
      }];

      input-field = map (monitor:
        with palette; {
          monitor = mkIf (monitor != null) monitor;
          size = {
            width = 210;
            height = 40;
          };
          outline_thickness = 2;
          outer_color = "0xff${lavender}";
          inner_color = "0xff${base}";
          font_color = "0xff${text}";
        }) (if builtins.length cfg.promptMonitors > 0 then
          cfg.promptMonitors
        else
          [ null ]);

      label = map (monitor:
        with palette; {
          monitor = mkIf (monitor != null) monitor;
          text = "$TIME";
          color = "0xff${text}";
          font_size = 36;
          font_family = "monospace";
        }) (if builtins.length cfg.promptMonitors > 0 then
          cfg.promptMonitors
        else
          [ null ]);
    };
  };
}
