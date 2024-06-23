{
  config,
  pkgs,
  lib,
  ...
}: let
  hostname = "YurigamineGakuen";
  username = "ririko";
in {
  imports = [
    ./disko-config.nix
  ];
  modules = {
    distributedBuilds.enable = true;
    fonts.enable = true;
    hyprland.enable = true;
    wine.enable = true;
    pipewire.enable = true;
    openssh.enable = true;
    graphics.enable = true;
  };

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_acpi"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    graphics.extraPackages = with pkgs; [
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

  environment.sessionVariables = {LIBVA_DRIVER_NAME = "i965";}; # Force intel-media-driver

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

  var.username = username;

  users = {
    users.${username} = {
      isNormalUser = true;
      description = "Hijiri Ririko";
      extraGroups = ["wheel"];
      shell = pkgs.fish;
      initialPassword = "amoledemulator";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUjt8Q4FYx79MfBQpN533bK2UTYk/H2TXAuM06bMyvP yotsuhameru@yotsuhameru.key"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    moonlight-qt
    firefox
  ];

  system.stateVersion = "24.05";
}
