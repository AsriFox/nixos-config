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
              users.users.asrifox = {
                description = "AsriFox";
                isNormalUser = true;
                extraGroups = [ "networkmanager" "wheel" ]
              };
              nix.settings.trusted-users = [ "asrifox" ];
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
              users.users.asrifox = {
                description = "AsriFox";
                isNormalUser = true;
                extraGroups = [ "networkmanager" "wheel" "libvirtd" ]
              };
              nix.settings.trusted-users = [ "asrifox" ];
            }
          ];
        };
      };

      homeConfigurations = {
        "asrifox@minibook" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/tower-nix/home-asrifox.nix
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
            ./hosts/tower-nix/home-asrifox.nix
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
      };
    };
}
