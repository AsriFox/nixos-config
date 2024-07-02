{ lib, pkgs, ... }: {
  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
    trusted-users = [ "root" "asrifox" ];
  };
  nixpkgs.config.allowUnfree = true;

  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = lib.mkForce "weston";
    };
    theme = "${import ../modules/sddm-theme.nix { inherit pkgs; }}";
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.hyprlock = { };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search <package>
  environment.systemPackages = with pkgs; [ weston kitty fish firefox ];

  fonts = {
    packages = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [ "FiraCode Nerd Font" ];
    };
  };

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  programs.git.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure.customRC = ''
      set smartindent
      set expandtab
      set shiftwidth=2
      set softtabstop=2
      set smarttab
      set tabstop=8
      set ignorecase
      set smartcase
    '';
  };

  # https://search.nixos.org/options?query=stateVersion&show=system.stateVersion
  system.stateVersion = "23.11";
}
