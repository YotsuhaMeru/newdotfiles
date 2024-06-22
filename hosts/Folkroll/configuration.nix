{pkgs, ...}: let
  hostname = "Folkroll"; # Define your hostname
  username = "kori";
in {
  modules = {
    mirakurun.enable = true;
    epgstation.enable = true;
    mysql.enable = true;
    openssh.enable = true;
    podman.enable = true;
    disableSleep.enable = true;
    cockpit.enable = true;
    hyprland.enable = true;
    jisLayout = {
      enable = true;
      x11 = true;
    };
    pipewire.enable = true;
    samba = {
      enable = true;
      inherit username;
      shares = {
        kori = {
          path = "/home/kori";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0755";
          "directory mask" = "0755";
          "valid users" = "kori";
        };
        komachi = {
          path = "/srv";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0755";
          "directory mask" = "0755";
          "valid users" = "kori";
        };
        meru = {
          path = "/var/www";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0755";
          "directory mask" = "0755";
          "valid users" = "kori";
        };
        chocolat = {
          path = "/mnt/hdd/";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0755";
          "directory mask" = "0755";
          "valid users" = "kori";
        };
        aira = {
          path = "/mnt/hdd2/";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0755";
          "directory mask" = "0755";
          "valid users" = "kori";
        };
      };
    };
  };
  var.username = username;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Miyohashi Kori";
    extraGroups = ["networkmanager" "wheel" "video"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqSrimj4asWCxAbiR5I2d7qRc4wTbnatyU55yg5Ih1x kori@Folkroll"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPEN4dIHBHXEpMJN954xil+8lPbcoFqWO5dVFnLVwzZ2"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvm29aFb1vnetFE991RDzawghS1T96ohKL6JlcxDo8V"
    ];
  };

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
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
  ];

  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0511", ATTRS{idProduct}=="0029", MODE="0664", GROUP="video"
  '';

  security.rtkit.enable = true;

  networking = {
    hostName = hostname;
    firewall = {
      enable = true;
      # Open ports in the firewall.
      allowedTCPPorts = [80 443 40772];
      # allowedUDPPorts = [ ... ];
      extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
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
