{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "ichika";
    homeDirectory = "/home/ichika";
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
