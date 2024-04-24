{
  description = "AsriFox's personal NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    system = "x86_64-linux";
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
        }
      ];
    };
      

    homeConfigurations = 
      let
        pkgs = nixpkgs.legacyPackages.${system};
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
            ./modules/cli-tools.nix
          ];
        };
      };
  };
}
