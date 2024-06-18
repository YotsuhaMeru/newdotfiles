{
  pkgs,
  inputs,
  ...
}: let
  hostname = "NixbookAir";
  username = "merutan1392";
  latestPkgs = import inputs.latest {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
      };
    };
    loader.efi.canTouchEfiVariables = false;
    kernelPackages = pkgs.linuxPackages;
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth = {
      enable = true;
    };
    kernelParams = [
      "i915.fastboot=1"
    ];
    supportedFilesystems = ["ntfs"];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "jp106";
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "jp";
      videoDrivers = ["intel"];
      deviceSection = ''
        Option "DRI" "3"
        Option "TearFree" "true"
      '';
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3lock
          i3status
        ];
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    blueman.enable = true;

    openvpn = {
      servers = {
        homeVPN = {config = ''config /home/merutan1392/OpenVPNConf.ovpn'';};
      };
    };
  };

  sound.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  var.username = username;
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/merutan1392";
    extraGroups = ["wheel" "networkmanager" "input" "audio" "video" "docker"];
  };

  environment.systemPackages = with pkgs; [
    polkit-kde-agent
    xdg-desktop-portal-wlr
    acpid
    discord
    firefox
    pciutils
    neofetch
    nodejs_18
    sl
    unzip
    gcc
    gnumake
    winetricks
    wineWowPackages.staging
    lutris
    ffmpeg
    tdesktop
    wirelesstools
    cifs-utils
    vulkan-tools
    ranger
    mpv
    swww
    gnupg
    feh
    appimage-run
    python311
    python311Packages.pip
    heroic
    yt-dlp
    softether
    blueman
    latestPkgs.unityhub
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  networking = {
    hostName = hostname;
    firewall.enable = true;
  };

  security.polkit = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "22.05";
}
