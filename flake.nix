{
  description = "my flake.nix";
  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
        url = "github:nix-community/home-manager/release-23.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };  

  outputs = { self, nixpkgs, nixpkgs-unstable, hyprland, home-manager, ...}: 
  {
    nixosConfigurations = {
      Folkroll = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/general.nix
          ./cachix
          ./hosts/Folkroll/configuration.nix
          ./hosts/Folkroll/hardware-configuration.nix
          ./srv_services/Folkroll
          ./hosts/Folkroll/webservices.nix
          home-manager.nixosModules.home-manager
          hyprland.nixosModules.default
          {
            programs.hyprland.enable = true;
            disabledModules = ["programs/hyprland.nix"];
          }
        ];
      };
      Mochizuki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/general.nix
          ./cachix
          ./hosts/Mochizuki/configuration.nix
          ./hosts/Mochizuki/hardware-configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
      ShirosuzuGakuen = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/general.nix
          ./cachix
          ./hosts/ShirosuzuGakuen/configuration.nix
          ./hosts/ShirosuzuGakuen/hardware-configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };

    homeConfigurations."kori@Folkroll" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        hyprland.homeManagerModules.default
       ./users/kori/home.nix
      ];
    };

    homeConfigurations."minato@ShirosuzuGakuen" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
       ./users/minato/home.nix
      ];
    };

  };
}

