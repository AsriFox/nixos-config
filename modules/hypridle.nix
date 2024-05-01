{ lib, pkgs, config, inputs, ... }:
let cfg = config.hypridle;
in with lib; {
  imports = [ inputs.hypridle.homeManagerModules.hypridle ];

  options.hypridle = with types; {
    enable = mkEnableOption "Hypridle config";
    lockCmd = mkOption {
      type = nullOr str;
      default = null;
    };
    lockTimeout = mkOption {
      type = int;
      default = 300;
    };
    hyprctl = mkOption {
      type = nullOr str;
      default = null;
    };
    dpmsTimeout = mkOption {
      type = int;
      default = 600;
    };
    suspendTimeout = mkOption {
      type = int;
      default = 1800;
    };
  };

  config.services.hypridle = mkIf cfg.enable {
    enable = true;
    lockCmd = mkIf (cfg.lockCmd != null) cfg.lockCmd;
    beforeSleepCmd = mkIf (cfg.lockCmd != null) cfg.lockCmd;
    listeners = (if cfg.lockCmd != null then [{
      timeout = cfg.lockTimeout;
      onTimeout = "loginctl lock-session";
    }] else
      [ ]) ++ (if cfg.hyprctl != null then [{
        timeout = cfg.dpmsTimeout;
        onTimeout = "${cfg.hyprctl} dispatch dpms off";
        onResume = "${cfg.hyprctl} dispatch dpms on";
      }] else
        [ ]) ++ [{
          timeout = cfg.suspendTimeout;
          onTimeout = "systemctl suspend";
        }];
  };
}
