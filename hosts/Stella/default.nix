{config, pkgs, lib, ...}:

{
  imports = [
    ./disko-config.nix
  ];
  networking.hostName = "Stella";
  networking.networkmanager.enable = true;

  boot.loader = {
    timeout = 0;
    systemd-boot = {
      enable = true;
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc" ];

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.initrd.kernelModules = ["i915"];
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };
  hardware.opengl.extraPackages = with pkgs; [
    (
      if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11")
      then vaapiIntel
      else intel-vaapi-driver
    )
    libvdpau-va-gl
    intel-media-driver
  ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  programs.fish.enable = true;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };


  var.username = "natsume";
  users = {
    users."natsume" = {
      isNormalUser = true;
      description = "Shiki Natsume";
      extraGroups = ["wheel"];
      shell = pkgs.fish;
      password = "defaultpassword";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm+N5E0ukbeM9lHJ/+1/iNyvqI3PhIECskTaANdmm/A natsume@Stella"
      ];
    };
  };

  system.stateVersion = "23.05";

}
