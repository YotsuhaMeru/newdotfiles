{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.ollama;
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
    services.ollama = {
      enable = true;
      acceleration = "cuda";
      environmentVariables = {
        OLLAMA_ORIGINS = "*"; # allow requests from any origins
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
          local_port = 11434;
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
