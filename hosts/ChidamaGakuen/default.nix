{config, lib, pkgs, ...}:

{
  imports = [
    ./disko-config.nix
  ];

  networking.hostName = "ChidamaGakuen";
  networking.useDHCP = lib.mkDefault true;
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

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  programs.fish.enable = true;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  var.username = "asumi";
  users = {
    users."asumi" = {
      isNormalUser = true;
      description = "Nishiki Asumi";
      extraGroups = ["wheel"];
      shell = pkgs.fish;
      password = "defaultpassword";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPkFm9YWn09p5GyYGImAz/lvPkeAjgu+ueOnJmdwDh0 Asumi@ChidamaGakuen"
      ];
    };
  };

  system.stateVersion = "23.05";


}
