_: {
  virtualisation.oci-containers.containers.alist = {
    image = "xhofe/alist:latest";
    user = "root:root";
    autoStart = true;
    environment = {
      PUID = "0";
      PGID = "0";
      UMASK = "022";
    };
    ports = [
      "5244:5244"
    ];
    volumes = [
      "/var/lib/alist:/opt/alist/data"
      "/mnt/hdd/SEGA_app_and_Game_Archive:/opt/alist/SEGAY"
    ];
    extraOptions = [
      # "--restart=unless-stopped"
    ];
  };

  networking.firewall.allowedTCPPorts = [5244];
}
