{pkgs, ...}: {
  systemd.services.minecraft_direwolf = {
    enable = false;
    description = "Minecraft Direwolf Server";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      TimeoutStopSec = "240s";
      WorkingDirectory = "/srv/server/minecraft_direwolf";
      ExecStart = "${pkgs.screen}/bin/screen -Dm -S mcserv ${pkgs.openjdk8}/lib/openjdk/bin/java -Xms8G -Xmx8G -XX:+UseG1GC -XX:MaxGCPauseMillis=25 -jar /srv/server/minecraft_direwolf/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui";
      ExecStop = "/srv/server/minecraft_direwolf/stop.sh";
      Restart = "always";
    };
  };
}
