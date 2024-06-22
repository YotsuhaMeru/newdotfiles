{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.mysql;
in {
  options = {
    modules.mysql = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };
}
