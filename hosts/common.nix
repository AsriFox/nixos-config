{ lib, pkgs, ... }: {
  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
    trusted-users = [ "root" ];
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

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.sddm.enableKwallet = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search <package>
  environment.systemPackages = with pkgs; [ weston fish firefox ];

  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = lib.mkForce "weston";
    };
  };

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
}
