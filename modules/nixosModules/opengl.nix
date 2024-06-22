{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.graphics;
in {
  options = {
    modules.graphics = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      enable32Bit = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    hardware.opengl = {
      # renamed to hardware.graphics on latest unstable
      enable = true;
      # enable32Bit = mkIf cfg.enable32Bit true;
      driSupport32Bit = true; # renamed to hardware.graphics.enable32Bit on latest unstable
    };
  };
}
