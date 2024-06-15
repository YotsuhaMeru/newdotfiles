{
  config,
  pkgs,
  lib,
  ...
}: let
  hostname = "Stella"; # Define your hostname
  username = "natsume";
in {
  imports = [
    ./disko-config.nix
  ];
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  boot = {
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
      };
    };
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc"];
  };

  hardware = {
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl.extraPackages = with pkgs; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11")
        then vaapiIntel
        else intel-vaapi-driver
      )
      libvdpau-va-gl
      intel-media-driver
    ];
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    bluetooth.enable = true;

    pulseaudio.enable = false;
  };

  boot.initrd.kernelModules = ["i915"];
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    microsoft-edge-beta
  ];

  programs.fish.enable = true;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  var.username = username;
  users.users.${username} = {
    isNormalUser = true;
    description = "Shiki Natsume";
    extraGroups = ["wheel"];
    shell = pkgs.fish;
    password = "defaultpassword";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm+N5E0ukbeM9lHJ/+1/iNyvqI3PhIECskTaANdmm/A natsume@Stella"
    ];
  };

  system.stateVersion = "23.05";
}
