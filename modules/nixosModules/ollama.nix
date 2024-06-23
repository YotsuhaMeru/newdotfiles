{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.ollama;
  ipSubnet = "172.26.0.0/16";
in {
  options = {
    modules.ollama = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      port = mkOption {
        type = types.int;
        default = 11451;
      };
      destAddr = mkOption {
        type = types.str;
        default = "192.168.0.185";
      };
      destPort = mkOption {
        type = types.int;
        default = 7154;
      };
    };
  };
  config = mkIf cfg.enable {
    modules.arion.enable = mkForce true;
    virtualisation.arion = {
      projects.ollama.settings = {
        project.name = "ollama";
        networks = {
          default = {
            name = "ollama";
            ipam = {
              config = [{subnet = ipSubnet;}];
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
            volumes = ["/home/${config.var.username}/ollama:/root/.ollama"];
            restart = "unless-stopped";
            ports = [
              "${builtins.toString cfg.port}:11434"
            ];
            labels."io.containers.autoupdate" = "registry";
          };
        };
      };
    };

    services.frp = {
      enable = true;
      role = "client";
      settings = {
        common = {
          server_addr = cfg.destAddr;
          server_port = cfg.destPort;
        };
        proxies = {
          name = "ollama";
          type = "tcp";
          local_ip = "127.0.0.1";
          local_port = cfg.port;
          remote_port = cfg.port;
        };
      };
    };

    systemd.services.arion-ollama = {
      wants = ["network-online.target"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
    };
  };
}
