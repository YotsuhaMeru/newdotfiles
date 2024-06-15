{pkgs, ...}: let
  hostname = "Folkroll"; # Define your hostname
  username = "kori";
in {
  # Configure console keymap
  console.keyMap = "jp106";

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
    packages = with pkgs; [];
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
    recfsusb2n
    mirakurun
    epgstation
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
  ];

  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];
    };
  };

  programs = {
    hyprland.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    xserver = {
      enable = false;
      displayManager = {
        lightdm.enable = false;
        defaultSession = "hyprland";
        autoLogin.enable = true;
        autoLogin.user = "kori";
      };
      layout = "jp";
      xkbVariant = "";
    };

    cockpit = {
      enable = true;
    };

    mirakurun = {
      enable = true;
      openFirewall = true;
      tunerSettings = [
        {
          name = "KTV-FSUSB2N";
          types = ["GR"];
          command = "${pkgs.recfsusb2n}/bin/recfsusb2n -b25 <channel> - -";
        }
      ];
    };
    epgstation = {
      enable = true;
      openFirewall = true;
      database.passwordFile = "/srv/key";
      settings.mirakurunPath = "http://127.0.0.1:40772";
    };
    samba-wsdd.enable = true;
    samba = {
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
        read raw = Yes
        write raw = Yes
        socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072
        min receivefile size = 16384
        use sendfile = true
        aio read size = 16384
        aio write size = 16384
      '';
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
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    # Use podman instead of docker
    oci-containers.backend = "podman";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0511", ATTRS{idProduct}=="0029", MODE="0664", GROUP="video"
  '';

  security.rtkit.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

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
