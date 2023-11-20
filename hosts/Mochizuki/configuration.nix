{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "Mochizuki"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    layout = "jp";
    xkbVariant = "";
  };


  # Configure console keymap
  console.keyMap = "jp106";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.autoSuspend = false;
  programs.hyprland.enableNvidiaPatches = false;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.pulseaudio.enable = false;
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.sessionVariables."NIXOS_OZONE_WL" = "1";

  environment.systemPackages = with pkgs; [
    firefox
    tdesktop
    pavucontrol
    discord
    (pkgs.makeDesktopItem {
      name = "discord";
      exec = "${pkgs.discord}/bin/discord --use-gl=desktop";
      desktopName = "Discord";
      #icon = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/discord.svg";
    })
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  var.username = "kaguya";
  users.users.kaguya = {
    isNormalUser = true;
    description = "Momose Kaguya";
    extraGroups = ["networkmanager" "wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDo2kTqESEv6lDQ/GmpIZXTamdBOEmeX4nviw2PY0hOY kaguya@Mochizuki"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
