{
  inputs,
  self,
  lib,
  ...
}: {
  flake = {
    deploy = {
      sshOpts = ["-t" "-p" "22"];
      fastConnection = true;
      autoRollback = true;
      magicRollback = false;
      nodes =
        builtins.mapAttrs
        (_: nixosConfig: {
          hostname = "${nixosConfig.config.networking.hostName}";

          profiles.system = {
            user = "root";
            sshUser = "${nixosConfig.config.var.username}";
            path = nixosConfig.pkgs.deploy-rs.lib.activate.nixos nixosConfig;
          };
        })
          self.nixosConfigurations;
    };

    # This is highly advised, and will prevent many possible mistakes
    checks =
      builtins.mapAttrs
      (_system: deployLib: deployLib.deployChecks self.deploy)
      inputs.deploy-rs.lib;
  };
}
