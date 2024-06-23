{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.podman;
in {
  options = {
    modules.podman = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      # Use podman instead of docker
      oci-containers.backend = "podman";
    };
  };
}
