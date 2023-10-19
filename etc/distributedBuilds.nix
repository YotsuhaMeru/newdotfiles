{
  config,
  pkgs,
  ...
}: {
  nix.buildMachines = [
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

  nix.settings.trusted-users = ["ichika" "kori" "kaguya"];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
