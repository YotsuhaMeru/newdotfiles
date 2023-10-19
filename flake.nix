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
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.url = "github:numtide/devshell";
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.nixos-flake.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.devshell.flakeModule
      ];

      flake = {
        nixosConfigurations = {
          # Central Server
          Folkroll = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              self.nixosModules.common
              ./hosts/Folkroll/configuration.nix
              ./hosts/Folkroll/hardware-configuration.nix
              ./srv_services/Folkroll
              ./hosts/Folkroll/webservices.nix
              inputs.home-manager.nixosModules.home-manager
              ({
                config,
                pkgs,
                ...
              }: {
                home-manager.users."kori" = {
                  imports = [
                    inputs.hyprland.homeManagerModules.default
                    {wayland.windowManager.hyprland.enable = true;}
                    ./users/kori/home.nix
                    ./etc/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # ThinClient Laptop
          Sweettail = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              self.nixosModules.common
              ./etc/fonts.nix
              ./etc/hyprland.nix
              ./etc/distributedBuilds.nix
              ./hosts/Sweettail/configuration.nix
              ./hosts/Sweettail/hardware-configuration.nix
              inputs.home-manager-unstable.nixosModules.home-manager
              ({
                config,
                pkgs,
                ...
              }: {
                home-manager.users."ichika" = {
                  imports = [
                    ./users/ichika/home.nix
                    ./etc/hmModules/starship.nix
                    ./users/ichika/hyprland
                    inputs.nixindb-unstable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # Desktop
          Mochizuki = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              self.nixosModules.common
              ./etc/fonts.nix
              ./etc/hyprland.nix
              ./etc/wine.nix
              ./hosts/Mochizuki/configuration.nix
              ./hosts/Mochizuki/hardware-configuration.nix
              inputs.home-manager-unstable.nixosModules.home-manager
              ({
                config,
                pkgs,
                ...
              }: {
                home-manager.users."kaguya" = {
                  imports = [
                    ./users/kaguya/home.nix
                    ./etc/hmModules/starship.nix
                    ./users/kaguya/hyprland
                    inputs.nixindb-unstable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # NAS Server
          ShirosuzuGakuen = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              self.nixosModules.common
              ./hosts/ShirosuzuGakuen/configuration.nix
              ./hosts/ShirosuzuGakuen/hardware-configuration.nix
              inputs.home-manager.nixosModules.home-manager
              ({
                config,
                pkgs,
                ...
              }: {
                home-manager.users."minato" = {
                  imports = [
                    ./users/minato/home.nix
                    ./etc/hmModules/starship.nix
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
          common = {pkgs, ...}: {
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
                experimental-features = ["nix-command" "flakes"];
                trusted-users = ["@wheel"];
                allowed-users = ["@wheel"];
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

      perSystem = {
        pkgs,
        self',
        system,
        lib,
        config,
        inputs',
        ...
      }: {
        treefmt = {
          programs.alejandra.enable = true;
          flakeFormatter = true;
          projectRootFile = "flake.nix";
        };
        # Not to be confused with capital S "devShells"
        devshells.default = {
          packages = [config.treefmt.build.wrapper pkgs.deploy-rs pkgs.fish];
        };
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.nur.overlay
          ];
        };
      };
    };
}
