{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.avahi;
in {
  options = {
    modules.avahi = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    # mdns service
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      # publish/announce machine
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        userServices = true;
        hinfo = true;
        workstation = true;
      };
    };
  };
}
