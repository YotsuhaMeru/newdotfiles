{
  pkgs,
  inputs,
  ...
}: let
  hostname = "NixbookAir";
  username = "merutan1392";
  latestPkgs = import inputs.latest {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in {
  modules = {
    fonts.enable = true;
    hyprland.enable = true;
    jisLayout = {
      enable = true;
      x11 = true;
    };
    pipewire.enable = true;
    graphics.enable = true;
    distributedBuilds.enable = true;
  };
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
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [pkgs.fcitx5-mozc];
    fcitx5.waylandFrontend = true;
  };

  services = {
    xserver = {
      enable = true;
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
    blueman.enable = true;
    mbpfan.enable = true;

    openvpn = {
      servers = {
        homeVPN = {config = ''config /home/merutan1392/OpenVPNConf.ovpn'';};
      };
    };
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
