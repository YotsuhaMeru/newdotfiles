{
  description = "my flake.nix";
  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "/nixos-unstable";
    };
    nur.url = "github:nix-community/nur";
    nixindb-stable = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixindb-unstable = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "/nixos-unstable";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.nixos-flake.flakeModule
      ];

      flake =
        {
          nixosConfigurations = {
            Folkroll = self.nixos-flake.lib.mkLinuxSystem {
              nixpkgs.hostPlatform = "x86_64-linux";
              imports = [
                self.nixosModules.common
                ./hosts/Folkroll/configuration.nix
                ./hosts/Folkroll/hardware-configuration.nix
                ./srv_services/Folkroll
                ./hosts/Folkroll/webservices.nix
                inputs.home-manager.nixosModules.home-manager
                ({ config, pkgs, ... }:
                  {
                    home-manager.users."kori" = {
                      imports = [
                        inputs.hyprland.homeManagerModules.default
                        {wayland.windowManager.hyprland.enable = true;}
                        ./users/kori/home.nix
                        inputs.nixindb-stable.hmModules.nix-index
                      ];
                    };
                  })
              ];
            };
            Mochizuki = inputs.nixos-unstable.lib.nixosSystem {
              # nixpkgs.hostPlatform = "x86_64-linux";
              system = "x86_64-linux";
              modules = [
                self.nixosModules.common
                ./etc/fonts.nix
                ./etc/hyprland.nix
                ./etc/wine.nix
                ./hosts/Mochizuki/configuration.nix
                ./hosts/Mochizuki/hardware-configuration.nix
                inputs.home-manager-unstable.nixosModules.home-manager
                ({ config, pkgs, ... }:
                  {
                    home-manager.users."kaguya" = {
                      imports = [
                        ./users/kaguya/home.nix
                        ./users/kaguya/starship.nix
                        ./users/kaguya/hyprland
                        inputs.nixindb-unstable.hmModules.nix-index
                      ];
                    };
                  })
              ];
            };
            ShirosuzuGakuen = self.nixos-flake.lib.mkLinuxSystem {
              nixpkgs.hostPlatform = "x86_64-linux";
              imports = [
                self.nixosModules.common
                ./hosts/ShirosuzuGakuen/configuration.nix
                ./hosts/ShirosuzuGakuen/hardware-configuration.nix
                inputs.home-manager.nixosModules.home-manager
                ({ config, pkgs, ... }:
                  {
                    home-manager.users."minato" = {
                      imports = [
                        ./users/minato/home.nix
                        inputs.nixindb-stable.hmModules.nix-index
                      ];
                    };
                  })
              ];
            };
          };
          # All nixos/nix-darwin configurations are kept here.
          nixosModules = {
            # Common nixos/nix-darwin configuration shared between Linux and macOS.
            common = { pkgs, ... }: {
              # Allow unfree packages
              nixpkgs = {
                config = {
                  allowUnfree = true;
                };
                overlays = [
                  inputs.nur.overlay
                ];
              };
              # Enable flakes
              nix = {
                settings = {
                  experimental-features = [ "nix-command" "flakes" ];
                  trusted-users = [ "@wheel" ];
                  allowed-users = [ "@wheel" ];
                };
              };
              imports = [
                ./cachix
                ./hosts/general.nix
              ];

            };
          };

        };


      #homeConfigurations."kori@Folkroll" = inputs.home-manager.lib.homeManagerConfiguration {
      #  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      #  modules = [
      #   ./users/kori/home.nix
      #  ];
      #};

      #homeConfigurations."minato@ShirosuzuGakuen" = inputs.home-manager.lib.homeManagerConfiguration {
      #  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      #  modules = [
      #   ./users/minato/home.nix
      #  ];
      #};

      perSystem = { pkgs, self', system, lib, config, inputs', ... }: {
        formatter = pkgs.nixpkgs-fmt;
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.nur.overlay
          ];
        };
      };
    };
}

