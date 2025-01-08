{ lib, config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "minibook";

  services.displayManager.sddm.theme =
    let background = /home/asrifox/Pictures/Wallpapers/1596796944195584330.jpg;
    in "${import ../../modules/sddm-theme.nix { inherit pkgs background; }}";

  services.displayManager.sddm.wayland.compositorCommand = let
    westonIni = (pkgs.formats.ini { }).generate "weston.ini" {
      output = {
        name = "DSI-1";
        mode = "preferred";
        scale = "2";
        transform = "rotate-270";
      };
      libinput = with config.services.xserver.libinput; {
        enable-tap = mouse.tapping;
        left-handed = mouse.leftHanded;
      };
      keyboard = with config.services.xserver.xkb; {
        keymap_model = model;
        keymap_layout = layout;
        keymap_variant = variant;
        keymap_options = options;
      };
    };
  in "${lib.getExe pkgs.weston} --shell=kiosk -c ${westonIni}";

  # https://search.nixos.org/options?query=stateVersion&show=system.stateVersion
  system.stateVersion = "23.11";
}
