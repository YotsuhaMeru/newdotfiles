{
 config,
 pkgs,
 lib,
 ...
}: 
{
  imports = [
    ./disko-config.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_acpi" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.loader = {
    timeout = 0;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; }; # Force intel-media-driver

  networking.hostName = "YurigamineGakuen";
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager = {
    enable = true;
    connectionConfig = {
      "connection.mdns" = 2;
      "connection.llmnr" = 0;
    };
  };
  networking.firewall.enable = true;
   
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  var.username = "ririko";

  users = {
    users."ririko" = {
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
