# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod"];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["kvm-intel"];
    kernelParams = ["intel_iommu=on"];
    supportedFilesystems = ["ntfs"];
    extraModulePackages = [];
    extraModprobeConfig = "options kvm_intel nested=1";
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/Mochizuki";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };

    "/mnt/hdd" = {
      device = "/dev/disk/by-label/Data";
      fsType = "ntfs-3g";
      options = ["rw"];
    };
  };

  swapDevices = [
    #  {device = "/dev/disk/by-uuid/f80b8840-b6af-4b3f-9967-da937ecf71bc";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  hardware = {
    enableAllFirmware = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  # Load amdgpu driver for Xorg and Wayland
  services.xserver.videoDrivers = ["amdgpu"];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
