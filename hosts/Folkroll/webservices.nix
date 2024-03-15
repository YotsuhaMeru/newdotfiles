{
  config,
  pkgs,
  ...
}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      ":443".extraConfig = ''
        abort 
      '';
      "cafe-setaria.com".extraConfig = ''
         reverse_proxy http://127.0.0.1:8080
      '';
      "redmine.cafe-setaria.com".extraConfig = ''
         reverse_proxy http://127.0.0.1:3000
      '';
    };
  };

  services.redmine.enable = true;

  services.phpfpm.pools.pool = {
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
  services.nginx.enable = true;
  services.nginx.defaultSSLListenPort = 8443;
  services.nginx.defaultHTTPListenPort = 8080;
  services.nginx = {
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "cafe-setaria.com" = {
        addSSL = true;
        enableACME = true;
        root = "/var/www/cafe-setaria.com";
        locations."~ \\.php$".extraConfig = ''
          fastcgi_pass  unix:${config.services.phpfpm.pools.pool.socket};
          fastcgi_index index.php;
        '';
      };
      /*"eewservlet.cafe-setaria.com" = {
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
      };*/
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "merutan1392s@gmail.com";
    certs = {
      "cafe-setaria.com".email = "merutan1392s@gmail.com";
    };
  };
}
