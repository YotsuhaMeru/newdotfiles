{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.epgstation;
in {
  options = {
    modules.epgstation = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      epgstation
    ];
    services.epgstation = {
      enable = true;
      openFirewall = true;
      database.passwordFile = "/srv/key";
      settings.mirakurunPath = "http://127.0.0.1:40772";
    };
  };
}
