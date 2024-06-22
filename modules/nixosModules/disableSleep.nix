{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.disableSleep;
in {
  options = {
    modules.disableSleep = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}
