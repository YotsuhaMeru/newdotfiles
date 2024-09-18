{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.distributedBuilds;
in {
  options = {
    modules.distributedBuilds = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    nix = {
      buildMachines = [
        {
          hostName = "Folkroll";
          system = "x86_64-linux";
          protocol = "ssh-ng";
          maxJobs = 3;
          speedFactor = 99999;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          mandatoryFeatures = [];
        }
      ];

      settings.trusted-users = ["ichika" "kori" "kaguya" "merutan1392"];
      distributedBuilds = true;
      extraOptions = ''
        builders-use-substitutes = true
      '';
    };
  };
}
