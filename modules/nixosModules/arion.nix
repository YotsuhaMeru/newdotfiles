{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.arion;
in {
  imports = [inputs.arion.nixosModules.arion];
  options = {
    modules.arion = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    virtualisation.arion = {
      backend = "podman-socket";
    };
    environment.systemPackages = with pkgs; [arion];
  };
}
