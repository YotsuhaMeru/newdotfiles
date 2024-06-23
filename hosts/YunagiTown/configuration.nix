{
  pkgs,
  lib,
  ...
}: let
  hostname = "YunagiTown";
  username = "kohana";
in {
  modules = {
    openssh.enable = true;
  };
  imports = [
    ./disko-config.nix
  ];

  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      connectionConfig = {
        "connection.mdns" = 2;
        "connection.llmnr" = 0;
      };
    };
    firewall.enable = true;
  };

  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_blk"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.hypervGuest.enable = true;

  var.username = username;

  users.users.${username} = {
    isNormalUser = true;
    description = "Kohana";
    extraGroups = ["wheel"];
    shell = pkgs.fish;
    password = "defaultpassword";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/SC3fS/8k2QExSVJyytXOWhO1W2GSeRQJ3eq4a/5gn kohana@YunagiTown"
    ];
  };

  programs.fish.enable = true;

  system.stateVersion = "23.11";
}
