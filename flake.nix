{
  description = "AsriFox's personal NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = let
        asrifox = {
          isNormalUser = true;
          description = "AsriFox";
          extraGroups = [ "networkmanager" "wheel" ];
        };
      in {
        minibook = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./cachix.nix
            ./hosts/common.nix
            ./hosts/minibook
            {
              services.displayManager.defaultSession = "plasma";
              services.desktopManager.plasma6.enable = true;
              users.users = { inherit asrifox; };
            }
          ];
        };
        tower-nix = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./cachix.nix
            ./hosts/common.nix
            ./hosts/tower-nix
            {
              services.displayManager.defaultSession = "plasma";
              services.desktopManager.plasma6.enable = true;
              users.users = { inherit asrifox; };
            }
            {
              virtualisation.libvirtd.enable = true;
              programs.virt-manager.enable = true;
              users.users.asrifox.extraGroups = [ "libvirtd" ];
            }
          ];
        };
      };

      homeConfigurations = let
        hmSettings = username: {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "23.11";
          };
          xdg.enable = true;
          programs.home-manager.enable = true;
        };
      in {
        "asrifox@minibook" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (hmSettings "asrifox")
            { services.network-manager-applet.enable = true; }
            ./modules
            {
              catppuccin = {
                enable = true;
                flavor = "macchiato";
              };
            }
          ];
          extraSpecialArgs = { inherit inputs; };
        };
        "asrifox@tower-nix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (hmSettings "asrifox")
            ./modules
            {
              catppuccin = {
                enable = true;
                flavor = "macchiato";
              };
            }
            {
              dconf.settings = {
                "org/virt-manager/virt-manager/connections" = {
                  autoconnect = [ "qemu:///system" ];
                  uris = [ "qemu:///system" ];
                };
              };
            }
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
