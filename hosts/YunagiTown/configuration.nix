{config, pkgs, lib, ...}:

{
  imports = [
    ./disko-config.nix
  ];

  networking.hostName = "YunagiTown";
  networking.networkmanager = {
    enable = true;
    connectionConfig = {
      "connection.mdns" = 2;
      "connection.llmnr" = 0;
    };
  };

  boot.loader = {
    timeout = 0;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.hypervGuest.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  networking.firewall.enable = true;

  var.username = "kohana";

  users = {
    users."kohana" = {
      isNormalUser = true;
      description = "Kohana";
      extraGroups = ["wheel"];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/SC3fS/8k2QExSVJyytXOWhO1W2GSeRQJ3eq4a/5gn kohana@YunagiTown"
      ];
    };
  };

  programs.fish.enable = true;

  system.stateVersion = "23.11";
}
