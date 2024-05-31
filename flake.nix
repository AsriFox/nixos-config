{
  description = "AsriFox's personal NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-cliphist.url = "github:benoitlouy/anyrun-cliphist";

    ags.url = "github:Aylur/ags";
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
            ./hosts/common.nix
            ./hosts/minibook
            {
              services.displayManager.defaultSession = "plasma";
              services.desktopManager.plasma6.enable = true;
              users.users = { inherit asrifox; };
              programs.hyprland = {
                enable = true;
                package = inputs.hyprland.packages.${system}.hyprland;
              };
            }
          ];
        };
        tower-nix = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/common.nix
            ./hosts/tower-nix
            {
              services.displayManager.defaultSession = "hyprland";
              services.desktopManager.plasma6.enable = true;
              users.users = { inherit asrifox; };
              programs.hyprland = {
                enable = true;
                package = inputs.hyprland.packages.${system}.hyprland;
              };
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
            ./hosts/minibook/hyprland.nix
            {
              catppuccin = {
                enable = true;
                flavour = "macchiato";
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
            ./hosts/tower-nix/hyprland.nix
            {
              catppuccin = {
                enable = true;
                flavour = "macchiato";
              };
            }
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
