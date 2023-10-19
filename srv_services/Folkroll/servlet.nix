{pkgs, ...}: {
  systemd.services.eewServlet = {
    enable = true;
    description = "eewServlet";
    after = ["network-online.target"];
    serviceConfig = {
      RestartSec = "1000ms";
      WorkingDirectory = "/srv/server/eewservlet/";
      ExecStart = "${pkgs.nodejs_18}/bin/node /srv/server/eewservlet/index.js";
      Restart = "always";
      KillMode = "process";
    };
    wantedBy = ["multi-user.target"];
  };
}
