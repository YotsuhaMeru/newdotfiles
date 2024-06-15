{
  description = "my flake.nix";
  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
    deploy-rs.url = "github:serokell/deploy-rs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.url = "github:numtide/devshell";
    disko.url = "github:nix-community/disko";
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.nixos-flake.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.devshell.flakeModule
        ./hosts/deploy.nix
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
              (_: {
                home-manager.users."kori" = {
                  imports = [
                    # inputs.hyprland.homeManagerModules.default
                    # {wayland.windowManager.hyprland.enable = true;}
                    ./users/kori/home.nix
                    ./etc/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # Vultr
          YunagiTown = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              self.nixosModules.common
              ./hosts/YunagiTown/configuration.nix
              inputs.disko.nixosModules.disko
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."kohana" = {
                  imports = [
                    ./users/kohana/home.nix
                    ./etc/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # Chromebox
          ChidamaGakuen = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              self.nixosModules.common
              ./hosts/ChidamaGakuen
              inputs.disko.nixosModules.disko
              inputs.home-manager.nixosModules.home-manager
              (_: {
                home-manager.users."asumi" = {
                  imports = [
                    ./users/asumi/home.nix
                    ./etc/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
                home-manager.users."hiyori" = {
                  imports = [
                    ./users/hiyori/home.nix
                    ./etc/hmModules/starship.nix
                    inputs.nixindb-stable.hmModules.nix-index
                  ];
                };
              })
            ];
          };
          # ATrust mt182
          YurigamineGakuen = inputs.nixos-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              self.nixosModules.common
              ./etc/fonts.nix
              ./etc/distributedBuilds.nix
              ./etc/wine.nix
              ./etc/hyprland.nix
              ./hosts/YurigamineGakuen
              inputs.disko.nixosModules.disko
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."ririko" = {
                  imports = [
                    ./users/ririko/home.nix
                    # from natsume
                    ./users/natsume/waybar.nix
                    ./etc/hmModules/starship.nix
                    ./etc/hmModules/ime.nix
                    ./etc/hmModules/hyprland
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
            modules = [
              self.nixosModules.common
              ./etc/fonts.nix
              ./etc/distributedBuilds.nix
              ./etc/wine.nix
              ./etc/hyprland.nix
              ./hosts/Stella
              inputs.disko.nixosModules.disko
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."natsume" = {
                  imports = [
                    ./users/natsume/home.nix
                    ./users/natsume/waybar.nix
                    ./etc/hmModules/starship.nix
                    ./etc/hmModules/ime.nix
                    ./etc/hmModules/hyprland
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
            modules = [
              self.nixosModules.common
              ./etc/fonts.nix
              ./etc/hyprland.nix
              ./hosts/NixbookAir/configuration.nix
              ./hosts/NixbookAir/hardware-configuration.nix
              inputs.home-manager-unstable.nixosModules.home-manager
              (_: {
                home-manager.users."merutan1392" = {
                  imports = [
                    ./users/merutan1392/home.nix
                    ./etc/hmModules/starship.nix
                    inputs.nixindb-unstable.hmModules.nix-index
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
              (_: {
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
          Mochizuki = self.nixos-flake.lib.nixosSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            modules = [
              self.nixosModules.common
              ./etc/fonts.nix
              ./etc/hyprland.nix
              ./etc/wine.nix
              ./etc/virtualization.nix
              ./hosts/Mochizuki/configuration.nix
              ./hosts/Mochizuki/hardware-configuration.nix
              inputs.home-manager.nixosModules.home-manager
              (_: {
                home-manager.users."kaguya" = {
                  imports = [
                    ./users/kaguya/home.nix
                    ./etc/hmModules/starship.nix
                    ./etc/hmModules/ime.nix
                    ./etc/hmModules/hyprland
                    ./users/kaguya/waybar.nix
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
              ./etc/windows.nix
              inputs.home-manager.nixosModules.home-manager
              (_: {
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
          iso = inputs.nixos-unstable.lib.nixosSystem {
            modules = [
              "${inputs.nixos-unstable}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              self.nixosModules.common
              ({
                pkgs,
                lib,
                ...
              }: {
                nixpkgs.hostPlatform = "x86_64-linux";
                users.users.nixos.openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBdCFoasNYvWwXHCiXamRIdiQCJK21lmxv5rGLPsB3v kohana@YunagiTown"
                ];
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
              ./etc/globalvars.nix
              ./etc/sshconf.nix
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
