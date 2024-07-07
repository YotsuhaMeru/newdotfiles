{pkgs, ...}: {
  systemd.user.services = {
    RazuBot = {
      enable = true;
      description = "Discord bots(Razubot)";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = "1000ms";
        WorkingDirectory = "/srv/privdisbot/RazuBot-1/";
        ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/RazuBot-1/index.js";
        Restart = "always";
        KillMode = "process";
      };
    };

    MusicBot = {
      enable = true;
      description = "Discord bots(MusicBot)";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      path = [pkgs.ffmpeg-full pkgs.neofetch];
      serviceConfig = {
        RestartSec = "1000ms";
        WorkingDirectory = "/srv/privdisbot/Discord-Dejico-MusicBot/";
        ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/Discord-Dejico-MusicBot/index.js ${pkgs.ffmpeg-full}/bin/";
        Restart = "always";
        KillMode = "process";
      };
    };

    kEnginePB = {
      enable = false;
      description = "Discord bots(kEnginePB)";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = "1000ms";
        WorkingDirectory = "/srv/privdisbot/kEnginePB/";
        ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/kEnginePB/index.mjs";
        Restart = "always";
        KillMode = "process";
      };
    };

    eewBot = {
      enable = false;
      description = "Discord bots(eewBot)";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = "1000ms";
        WorkingDirectory = "/srv/privdisbot/fuckoffeew/";
        ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/fuckoffeew/index.js";
        Restart = "always";
        KillMode = "process";
      };
    };

    gomamayoBot = {
      enable = false;
      description = "Discord bots(gomamayoBot)";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = "1000ms";
        WorkingDirectory = "/srv/privdisbot/gomamayo/";
        ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/gomamayo/index.js";
        Restart = "always";
        KillMode = "process";
      };
    };

    GraybotCanary = {
      enable = true;
      description = "Discord bots(GraybotCanary)";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = "1000ms";
        WorkingDirectory = "/srv/privdisbot/GrayBot-Voice/";
        ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/GrayBot-Voice/index.js";
        Restart = "always";
        KillMode = "process";
      };
    };
    r-notify = {
      enable = true;
      description = "Discord bots(r-notify)";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = "1000ms";
        WorkingDirectory = "/srv/privdisbot/r-notify/";
        ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/r-notify/index.js";
        Restart = "always";
        KillMode = "process";
      };
    };
    ipnotify = {
      enable = true;
      description = "Discord bots(ipnotify)";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = "1000ms";
        WorkingDirectory = "/srv/privdisbot/ipnotify/";
        ExecStart = "${pkgs.nodejs_18}/bin/node /srv/privdisbot/ipnotify/index.js";
        Restart = "always";
        KillMode = "process";
      };
    };
  };
}
