{
  description = "AsriFox's personal NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
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
          services.displayManager.defaultSession = "plasma";
          services.desktopManager.plasma6.enable = true;
          users.users.asrifox = {
            isNormalUser = true;
            description = "AsriFox";
            extraGroups = [ "networkmanager" "wheel" ];
          };
          programs.hyprland.enable = true;
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
            ./modules/stylix.nix
            ./modules/cli-tools.nix
            {
              imports = [
                ./modules/hyprland.nix
              ];
              hyprland = {
                enable = true;
                monitors = [
                  {
                    name = "DSI-1";
                    scale = 2;
                    extra = [ "transform,3" ];
                    workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
                    wallpaper = "/home/asrifox/Pictures/Wallpapers/1596796944195584330.jpg";
                  }
                ];
              };
            }
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
  };
}
