{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.jisLayout;
in {
  options = {
    modules.jisLayout = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      x11 = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    # Configure console keymap
    console.keyMap = "jp106";

    services.xserver = mkIf cfg.x11 {
      # Configure keymap in X11
      xkb = {
        layout = "jp";
        variant = "";
      };
    };
  };
}
