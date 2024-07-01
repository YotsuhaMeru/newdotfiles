{config, ...}: let
  currentdomain = "cafe-setaria.net";
in {
  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        ":443".extraConfig = ''
          abort
        '';
        ${currentdomain}.extraConfig = ''
          reverse_proxy http://127.0.0.1:8080
        '';
        "redmine.${currentdomain}".extraConfig = ''
          reverse_proxy http://127.0.0.1:3000
        '';
      };
    };

    redmine.enable = true;

    phpfpm.pools.pool = {
      user = "nobody";
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
      };
    };
    phpfpm.phpOptions = ''
      upload_max_filesize = '5000M'
      post_max_size = '5000M'
      memory_limit = '6144M'
    '';
    nginx = {
      enable = true;
      defaultSSLListenPort = 8443;
      defaultHTTPListenPort = 8080;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        ${currentdomain} = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/${currentdomain}";
          locations."~ \\.php$".extraConfig = ''
            fastcgi_pass  unix:${config.services.phpfpm.pools.pool.socket};
            fastcgi_index index.php;
          '';
        };
        /*
          "eewservlet.cafe-setaria.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3678";
            proxyWebsockets = true; # needed if you need to use WebSocket
            extraConfig =
              # required when the target is also TLS server with multiple hosts
              "proxy_ssl_server_name on;"
              +
              # required when the server wants to use HTTP Authentication
              "proxy_pass_header Authorization;";
          };
        };
        "prd-djcbot.cafe-setaria.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:6888";
            proxyWebsockets = true; # needed if you need to use WebSocket
            extraConfig =
              # required when the target is also TLS server with multiple hosts
              "proxy_ssl_server_name on;"
              +
              # required when the server wants to use HTTP Authentication
              "proxy_pass_header Authorization;";
          };
        };
        "dev-djcbot.cafe-setaria.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:6555";
            proxyWebsockets = true; # needed if you need to use WebSocket
            extraConfig =
              # required when the target is also TLS server with multiple hosts
              "proxy_ssl_server_name on;"
              +
              # required when the server wants to use HTTP Authentication
              "proxy_pass_header Authorization;";
          };
        };
        "tomandjellyservlet.cafe-setaria.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.0.224:8096";
            proxyWebsockets = true; # needed if you need to use WebSocket
            extraConfig =
              # required when the target is also TLS server with multiple hosts
              "proxy_ssl_server_name on;"
              +
              # required when the server wants to use HTTP Authentication
              "proxy_pass_header Authorization;";
          };
        };
        */
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "yotsuhameru@gmail.com";
    certs = {
      ${currentdomain}.email = "yotsuhameru@gmail.com";
    };
  };
}
