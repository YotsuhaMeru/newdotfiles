{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "Folkroll"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    layout = "jp";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "jp106";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kori = {
    isNormalUser = true;
    description = "Miyohashi Kori";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPEN4dIHBHXEpMJN954xil+8lPbcoFqWO5dVFnLVwzZ2"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvm29aFb1vnetFE991RDzawghS1T96ohKL6JlcxDo8V"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqSrimj4asWCxAbiR5I2d7qRc4wTbnatyU55yg5Ih1x kori@Folkroll"
    ];
    packages = with pkgs; [];
  };

  programs.hyprland.enable = true;

  nix.settings.trusted-users = ["ichika" "kori"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    openjdk17
    nodejs_18
    python3
    gnumake
    gcc
    ffmpeg
    libuuid
  ];

  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "hyprland";
      autoLogin.enable = true;
      autoLogin.user = "kori";
    };
  };

  services.cockpit = {
    enable = true;
  };

  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = folkroll
      netbios name = folkroll
      security = user
      usershare allow guests = no
      restrict anonymous = 2
    '';
    shares = {
      kori = {
        path = "/home/kori";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "kori";
      };
      komachi = {
        path = "/srv";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "kori";
      };
      meru = {
        path = "/var/www";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "kori";
      };
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [80 443];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
