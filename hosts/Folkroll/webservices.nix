{
  config,
  pkgs,
  ...
}: {
  services.nginx.enable = true;
  services.nginx = {
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "cafe-setaria.com" = {
        addSSL = true;
        enableACME = true;
        root = "/var/www/cafe-setaria.com";
      };
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
      "folkroll-cock.cafe-setaria.com" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "https://127.0.0.1:9090";
          proxyWebsockets = true; # needed if you need to use WebSocket
          extraConfig =
            # required when the target is also TLS server with multiple hosts
            "proxy_ssl_server_name on;"
            +
            # required when the server wants to use HTTP Authentication
            "proxy_pass_header Authorization;";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "merutan1392s@gmail.com";
    certs = {
      "cafe-setaria.com".email = "merutan1392s@gmail.com";
    };
  };
}
