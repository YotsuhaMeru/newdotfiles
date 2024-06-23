{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.wine;
in {
  options = {
    modules.wine = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wineWowPackages.staging
      wineWowPackages.waylandFull
      winetricks
      gamescope
      mangohud
    ];
  };
}
