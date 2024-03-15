{pkgs, ...}: {
  # Razubot
  systemd.services.RazuBot = {
    enable = true;
    description = "Discord bots(Razubot)";
    after = ["network-online.target"];
    serviceConfig = {
      RestartSec = "1000ms";
      WorkingDirectory = "/srv/privdisbot/RazuBot-1/";
      ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/RazuBot-1/index.js";
      Restart = "always";
      KillMode = "process";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.MusicBot = {
    enable = true;
    description = "Discord bots(MusicBot)";
    after = ["network-online.target"];
    path = [pkgs.ffmpeg-full];
    serviceConfig = {
      RestartSec = "1000ms";
      WorkingDirectory = "/srv/privdisbot/Discord-Dejico-MusicBot/";
      ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/Discord-Dejico-MusicBot/index.js ${pkgs.ffmpeg-full}/bin/";
      Restart = "always";
      KillMode = "process";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.kEnginePB = {
    enable = false;
    description = "Discord bots(kEnginePB)";
    after = ["network-online.target"];
    serviceConfig = {
      RestartSec = "1000ms";
      WorkingDirectory = "/srv/privdisbot/kEnginePB/";
      ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/kEnginePB/index.mjs";
      Restart = "always";
      KillMode = "process";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.eewBot = {
    enable = false;
    description = "Discord bots(eewBot)";
    after = ["network-online.target"];
    serviceConfig = {
      RestartSec = "1000ms";
      WorkingDirectory = "/srv/privdisbot/fuckoffeew/";
      ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/fuckoffeew/index.js";
      Restart = "always";
      KillMode = "process";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.gomamayoBot = {
    enable = false;
    description = "Discord bots(gomamayoBot)";
    after = ["network-online.target"];
    serviceConfig = {
      RestartSec = "1000ms";
      WorkingDirectory = "/srv/privdisbot/gomamayo/";
      ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/gomamayo/index.js";
      Restart = "always";
      KillMode = "process";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.GraybotCanary = {
    enable = true;
    description = "Discord bots(GraybotCanary)";
    after = ["network-online.target"];
    serviceConfig = {
      RestartSec = "1000ms";
      WorkingDirectory = "/srv/privdisbot/GrayBot-Voice/";
      ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/GrayBot-Voice/index.js";
      Restart = "always";
      KillMode = "process";
    };
    wantedBy = ["multi-user.target"];
  };
}
