{
  config,
  pkgs,
  ...
}: {
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    timeout = 0;
    systemd-boot = {
      enable = true;
    };
  };
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelPackages = pkgs.linuxPackages;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.plymouth = {
    enable = true;
  };
  boot.kernelParams = [
    "i915.fastboot=1"
  ];
  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "NixbookAir";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "jp106";
  };

  services.xserver = {
    enable = true;
    layout = "jp";
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

  sound.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  users = {
    users.merutan1392 = {
      isNormalUser = true;
      home = "/home/merutan1392";
      extraGroups = ["wheel" "networkmanager" "input" "audio" "video" "docker"];
    };
  };

  services.openvpn = {
    servers = {
      homeVPN = {config = ''config /home/merutan1392/OpenVPNConf.ovpn'';};
    };
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
    unityhub
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  security.polkit = {
    enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;

  networking.firewall.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "22.05";
}
