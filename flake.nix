{
  description = "my flake.nix";
  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    latest.url = "github:nixos/nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "/nixos-unstable";
    };
    nur.url = "github:nix-community/nur";
    nixindb-stable = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixindb-unstable = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "/nixos-unstable";
    };
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.url = "github:numtide/devshell";
    disko.url = "github:nix-community/disko";
  };

  outputs = inputs @ {self, ...}: let
    specialArgs = {
      inherit
        self
        inputs
        ;
    };
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.devshell.flakeModule
        ./hosts/deploy.nix
      ];

      flake = {
        nixosConfigurations = {
          # Central Server (ChromeBox)
          Folkroll = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/Folkroll/configuration.nix
              ./hosts/Folkroll/hardware-configuration.nix
              ./srv_services/Folkroll
              ./hosts/Folkroll/webservices.nix
              inputs.home-manager.nixosModules.home-manager
              (_: {
                home-manager.users."kori" = {
                  imports = [
                    # inputs.hyprland.homeManagerModules.default
                    # {wayland.windowManager.hyprland.enable = true;}
                    ./users/kori/home.nix
                    ./modules/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # Vultr
          YunagiTown = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/YunagiTown/configuration.nix
              inputs.disko.nixosModules.disko
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."kohana" = {
                  imports = [
                    ./users/kohana/home.nix
                    ./modules/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # Deskmini
          ChidamaGakuen = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/ChidamaGakuen
              inputs.disko.nixosModules.disko
              inputs.home-manager.nixosModules.home-manager
              (_: {
                home-manager.users."asumi" = {
                  imports = [
                    ./users/asumi/home.nix
                    ./modules/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
                home-manager.users."hiyori" = {
                  imports = [
                    ./users/hiyori/home.nix
                    ./modules/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # ATrust mt182
          YurigamineGakuen = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/YurigamineGakuen
              inputs.disko.nixosModules.disko
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."ririko" = {
                  imports = [
                    ./users/ririko/home.nix
                    # from natsume
                    ./users/natsume/waybar.nix
                    ./modules/hmModules/starship.nix
                    ./modules/hmModules/ime.nix
                    ./modules/hmModules/hyprland
                    # from kaguya
                    ./users/kaguya/hyprland
                    inputs.nixindb-unstable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # x240
          Stella = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/Stella
              inputs.disko.nixosModules.disko
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."natsume" = {
                  imports = [
                    ./users/natsume/home.nix
                    ./users/natsume/waybar.nix
                    ./modules/hmModules/starship.nix
                    ./modules/hmModules/ime.nix
                    ./modules/hmModules/hyprland
                    # from kaguya
                    ./users/kaguya/hyprland
                    inputs.nixindb-unstable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # MBA
          NixbookAir = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/NixbookAir/configuration.nix
              ./hosts/NixbookAir/hardware-configuration.nix
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."merutan1392" = {
                  imports = [
                    ./users/merutan1392/home.nix
                    ./modules/hmModules/starship.nix
                    inputs.nixindb-unstable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # ThinClient Laptop
          Sweettail = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/Sweettail/configuration.nix
              ./hosts/Sweettail/hardware-configuration.nix
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."ichika" = {
                  imports = [
                    ./users/ichika/home.nix
                    ./modules/hmModules/starship.nix
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
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/Mochizuki/configuration.nix
              ./hosts/Mochizuki/hardware-configuration.nix
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."kaguya" = {
                  imports = [
                    ./users/kaguya/home.nix
                    ./modules/hmModules/starship.nix
                    ./modules/hmModules/ime.nix
                    ./modules/hmModules/hyprland
                    ./users/kaguya/waybar.nix
                    ./users/kaguya/hyprland
                    inputs.nixindb-unstable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # NAS Server
          ShirosuzuGakuen = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              self.nixosModules.common
              ./hosts/ShirosuzuGakuen/configuration.nix
              ./hosts/ShirosuzuGakuen/hardware-configuration.nix
              inputs.home-manager.nixosModules.home-manager
              (_: {
                home-manager.users."minato" = {
                  imports = [
                    ./users/minato/home.nix
                    ./modules/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          iso = inputs.nixos-unstable.lib.nixosSystem {
            inherit specialArgs;
            modules = [
              "${inputs.nixos-unstable}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              self.nixosModules.common
              ({
                pkgs,
                lib,
                ...
              }: {
                nixpkgs.hostPlatform = "x86_64-linux";
                var.username = "nixos";
                zramSwap = {
                  enable = true;
                  memoryPercent = 100;
                };
                networking.wireless.enable = lib.mkForce false;
                environment.systemPackages = with pkgs; [
                  rsync
                ];
              })
            ];
          };
        };
        # All nixos/nix-darwin configurations are kept here.
        nixosModules = {
          # Common nixos/nix-darwin configuration shared between Linux and macOS.
          common = {...}: {
            # Allow unfree packages
            nixpkgs = {
              config = {
                allowUnfree = true;
              };
              overlays = [
                (final: prev: import ./pkgs final prev)
                inputs.nur.overlay
                (
                  final: prev: {
                    deploy-rs = {
                      inherit (prev) deploy-rs;
                      inherit ((inputs.deploy-rs.overlay final prev).deploy-rs) lib;
                    };
                  }
                )
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
              ./modules/nixosModules
            ];
          };
        };
      };

      perSystem = {
        pkgs,
        system,
        config,
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
