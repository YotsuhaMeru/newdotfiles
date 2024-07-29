{pkgs, ...}: {
  systemd.user.services.eewServlet = {
    enable = false;
    description = "eewServlet";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      RestartSec = "1000ms";
      WorkingDirectory = "/srv/server/eewservlet/";
      ExecStart = "${pkgs.nodejs_18}/bin/node /srv/server/eewservlet/index.js";
      Restart = "always";
      KillMode = "process";
    };
  };
}
