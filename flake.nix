{
  description = "AsriFox's personal NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprgrass = {
       url = "github:horriblename/hyprgrass";
       inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.minibook = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/common.nix
        ./hosts/minibook
        {
          nix.settings = {
            substituters = ["https://hyprland.cachix.org"];
            trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
          };
          services.displayManager.defaultSession = "plasma";
          services.desktopManager.plasma6.enable = true;
          users.users.asrifox = {
            isNormalUser = true;
            description = "AsriFox";
            extraGroups = [ "networkmanager" "wheel" ];
          };
          programs.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${system}.hyprland;
          };
        }

        # Waiting for https://github.com/danth/stylix/issues/51 and https://github.com/danth/stylix/issues/74
        #stylix.nixosModules.stylix
        #{
        #  stylix = {
        #    image = "/home/asrifox/Pictures/Wallpapers/1596796944195584330.jpg";
        #    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
        #    fonts = {
        #      monospace = {
        #        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        #        name = "FiraCode Nerd Font";
        #      };
        #    };
        #  };
        #}
      ];
    };
      

    homeConfigurations = 
      let
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
            {
              services.network-manager-applet.enable = true;
            }
            ./modules/stylix.nix
            ./modules/cli-tools.nix
            ./modules/hyprland.nix
            ./hosts/minibook/hyprland.nix
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
  };
}
