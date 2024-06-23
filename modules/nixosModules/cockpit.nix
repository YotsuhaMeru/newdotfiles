{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.cockpit;
in {
  options = {
    modules.cockpit = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    services.cockpit.enable = true;
  };
}
