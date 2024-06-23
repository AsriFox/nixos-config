{ lib, pkgs, config, inputs, ... }:
let cfg = config.hypridle;
in with lib; {
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
    settings = {
      general = {
        lock_cmd = mkIf (cfg.lockCmd != null) cfg.lockCmd;
        before_sleep_cmd = mkIf (cfg.lockCmd != null) cfg.lockCmd;
      };
      listener = (if cfg.lockCmd != null then [{
        timeout = cfg.lockTimeout;
        on-timeout = "loginctl lock-session";
      }] else
        [ ]) ++ (if cfg.hyprctl != null then [{
          timeout = cfg.dpmsTimeout;
          on-timeout = "${cfg.hyprctl} dispatch dpms off";
          on-resume = "${cfg.hyprctl} dispatch dpms on";
        }] else
          [ ]) ++ [{
            timeout = cfg.suspendTimeout;
            on-timeout = "systemctl suspend";
          }];
    };
  };
}
