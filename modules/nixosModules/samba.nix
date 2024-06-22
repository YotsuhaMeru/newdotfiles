{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.samba;
in {
  options = {
    modules.samba = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      username = mkOption {
        type = types.str;
        default = "";
      };
      shares = mkOption {
        type = types.attrsOf (types.attrsOf types.unspecified);
        default = {};
      };
    };
  };
  config = mkIf cfg.enable {
    services = {
      samba-wsdd.enable = true;
      samba = {
        enable = false;
        securityType = "user";
        extraConfig = ''
          workgroup = WORKGROUP
          server string = ${cfg.username}
          netbios name = ${cfg.username}
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
        inherit (cfg) shares;
      };
    };
  };
}
