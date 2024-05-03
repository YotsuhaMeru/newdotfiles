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
  networking.firewall.enable = true;

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

  var.username = "asumi";
  users = {
    users."asumi" = {
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
