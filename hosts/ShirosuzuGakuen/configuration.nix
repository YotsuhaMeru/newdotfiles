{
  config,
  pkgs,
  lib,
  ...
}: let
  hostname = "ShirosuzuGakuen"; # Define your hostname.
  username = "minato";
in {
  console = {
    font = "Lat2-Terminus16";
    keyMap = "jp106";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
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
        serviceConfig = {
          RestartSec = "1000ms";
          WorkingDirectory = "/srv/privdisbot/RazuBot-1/";
          ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/RazuBot-1/index.js";
          Restart = "always";
          KillMode = "process";
        };
        wantedBy = ["multi-user.target"];
      };
      arion-ollama = {
        wants = ["network-online.target"];
        after = ["network-online.target"];
      };
    };
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
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
    nvtop
    python3
    screen
    nodejs_18
  ];

  programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services = {
    xserver.videoDrivers = ["nvidia"];

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
    samba-wsdd.enable = true;
    resolved = {
      enable = true;
      extraConfig = ''
        LLMNR=false
        ReadEtcHosts=false
        MulticastDNS=true
      '';
    };

    frp = {
      enable = true;
      role = "client";
      settings = {
        common = {
          server_addr = "192.168.0.134";
          server_port = 7154;
        };
        proxies = {
          name = "ollama";
          type = "tcp";
          local_ip = "127.0.0.1";
          local_port = 11451;
          remote_port = 11451;
        };
      };
    };

    memcached = {
      enable = true;
      maxMemory = 128;
    };

    jellyfin.enable = true;

    samba = {
      enable = false;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = shirosuzugakuen
        netbios name = shirosuzugakuen
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

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    # Use podman instead of docker
    oci-containers.backend = "podman";
    arion = {
      backend = "podman-socket";
      projects.ollama.settings = {
        project.name = "ollama";
        networks = {
          default = {
            name = "ollama";
            ipam = {
              config = [{subnet = "172.26.0.0/16";}];
            };
          };
        };
        services.ollama = {
          out.service = {
            deploy.resources.reservations.devices = lib.singleton {
              driver = "nvidia";
              count = 1;
              capabilities = ["gpu"];
            };
          };
          service = {
            image = "ollama/ollama:latest";
            container_name = "ollama";
            environment = {
              OLLAMA_ORIGINS = "*"; # allow requests from any origins
              HSA_OVERRIDE_GFX_VERSION = "10.3.0";
            };
            volumes = ["/home/${username}/ollama:/root/.ollama"];
            restart = "unless-stopped";
            ports = [
              "127.0.0.1:11451:11434"
            ];
            labels."io.containers.autoupdate" = "registry";
          };
        };
      };
    };
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
