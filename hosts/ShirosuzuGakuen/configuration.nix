{
  config,
  pkgs,
  ...
}: let
  hostname = "ShirosuzuGakuen"; # Define your hostname.
  username = "minato";
in {
  modules = {
    windows.enable = true;
    jisLayout.enable = true;
    openssh.enable = true;
    podman.enable = true;
    ollama.enable = true;
    graphics.enable = true;
    disableSleep.enable = true;
    samba = {
      enable = false;
      inherit username;
      shares = {
        kazari = {
          path = "/mnt/hdd/";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0755";
          "directory mask" = "0755";
          "valid users" = "minato";
          "invalid users" = "hinata";
        };
        hinata = {
          path = "/mnt/hdd2/";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0755";
          "directory mask" = "0755";
          "valid users" = "minato";
          "invalid users" = "hinata";
        };
        VN_Share = {
          path = "/mnt/hdd/Share/iso/VN_Share/";
          browseable = "yes";
          "read only" = "yes";
          "guest ok" = "no";
          "valid users" = "minato, hinata";
        };
        nanami = {
          path = "/mnt/hdd/Share/rwshare/";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "valid users" = "minato, yuzu";
        };
      };
    };
  };
  console = {
    font = "Lat2-Terminus16";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  systemd = {
    services = {
      SdBot = {
        enable = false;
        description = "Discord bots(sdbot)";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          RestartSec = "1000ms";
          WorkingDirectory = "/srv/privdisbot/RazuBot-1/";
          ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/RazuBot-1/index.js";
          Restart = "always";
          KillMode = "process";
        };
      };
    };
  };

  var.username = username;
  # Define a user account. Don't forget to set a password with passwd.
  users.users = {
    ${username} = {
      isNormalUser = true;
      description = "Asuka Minato";
      extraGroups = ["wheel"]; # Enable `sudo` for the user.
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQEd6x7x71UyE0AQOF9Www22mUm/eScmL1zHkOUIYJP minato@ShirosuzuGakuen"
      ];
    };
    hinata = {
      isNormalUser = true;
    };
    yuzu = {
      isNormalUser = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    cudaPackages_12_1.cudatoolkit
    nvtopPackages.full
    python3
    screen
    nodejs_18
  ];

  # List services that you want to enable:

  services = {
    xserver.videoDrivers = ["nvidia"];

    # Enable the OpenSSH daemon.
    resolved = {
      enable = true;
      extraConfig = ''
        LLMNR=false
        ReadEtcHosts=false
        MulticastDNS=true
      '';
    };

    memcached = {
      enable = true;
      maxMemory = 128;
    };

    jellyfin.enable = true;
  };

  networking = {
    hostName = hostname;

    networkmanager = {
      enable = true;
      connectionConfig = {
        "connection.mdns" = 2;
        "connection.llmnr" = 0;
      };
    };
    firewall = {
      enable = true;
      extraCommands = ''
        iptables -A INPUT -p tcp --destination-port 53 -s 172.26.0.0/16 -j ACCEPT
        iptables -A INPUT -p udp --destination-port 53 -s 172.26.0.0/16 -j ACCEPT
      '';
      # Open ports in the firewall.
      allowedTCPPorts = [7860 11451];
      # allowedUDPPorts = [ ... ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
