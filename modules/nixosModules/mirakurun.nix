{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.mirakurun;
in {
  options = {
    modules.mirakurun = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mirakurun
      recfsusb2n
    ];
    services.mirakurun = {
      enable = true;
      openFirewall = true;
      tunerSettings = [
        {
          name = "KTV-FSUSB2N";
          types = ["GR"];
          command = "${pkgs.recfsusb2n}/bin/recfsusb2n -b25 <channel> - -";
        }
      ];
    };
  };
}
