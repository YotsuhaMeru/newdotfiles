{
  config,
  lib,
  pkgs,
  ...
}: let
  hostname = "ChidamaGakuen";
  username = "asumi";
in {
  imports = [
    ./disko-config.nix
  ];

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
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

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  virtualisation.podman.enable = true;
  environment.systemPackages = with pkgs; [
    distrobox
  ];
  programs.fish.enable = true;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  var.username = username;
  users = {
    users.${username} = {
      isNormalUser = true;
      description = "Nishiki Asumi";
      extraGroups = ["wheel"];
      shell = pkgs.fish;
      initialPassword = "defaultpassword";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPkFm9YWn09p5GyYGImAz/lvPkeAjgu+ueOnJmdwDh0 Asumi@ChidamaGakuen"
      ];
    };
    users."hiyori" = {
      isNormalUser = true;
      description = "Izumi Hiyori";
      extraGroups = ["wheel"];
      shell = pkgs.fish;
      initialPassword = "alpinerickroll";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9QP7hABDQ+esrZnDhQulFfrhfuT8cPmREYvtPRzjF4 93813719+nyawox@users.noreply.github.com"
      ];
    };
  };

  system.stateVersion = "23.05";
}
