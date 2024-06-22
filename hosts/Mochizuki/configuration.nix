{pkgs, ...}: let
  hostname = "Mochizuki"; # Define your hostname.
  username = "kaguya";
in {
  modules = {
    fonts.enable = true;
    hyprland.enable = true;
    virtualisation.enable = true;
    wine.enable = true;
    jisLayout = {
      enable = true;
      x11 = true;
    };
    pipewire.enable = true;
    openssh.enable = true;
    disableSleep.enable = true;
    graphics.enable = true;
  };
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      displayManager.gdm.autoSuspend = false;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = false;
      desktopManager.gnome.enable = true;
    };
    blueman.enable = true;
  };

  hardware.pulseaudio.enable = false;
  sound.enable = true;
  security.rtkit.enable = true;
  environment.sessionVariables."NIXOS_OZONE_WL" = "1";

  environment.systemPackages = with pkgs; [
    firefox
    tdesktop
    pavucontrol
    swww
    usbmuxd
    vesktop
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

  var.username = username;
  users.users.${username} = {
    isNormalUser = true;
    description = "Momose Kaguya";
    extraGroups = ["networkmanager" "wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDo2kTqESEv6lDQ/GmpIZXTamdBOEmeX4nviw2PY0hOY kaguya@Mochizuki"
    ];
  };

  networking = {
    hostName = hostname;
    firewall = {
      enable = true;
      # Open ports in the firewall.
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
