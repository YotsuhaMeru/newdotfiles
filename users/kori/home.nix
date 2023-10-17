{ config, pkgs, ...}:

{
  home = {
    username = "kori";
    homeDirectory = "/home/kori";
  };

  wayland.windowManager.hyprland = {
            enable = true;
            extraConfig = ''
               autogenerated = 0
               # exec-once = /etc/nixos/boot.sh
               monitor = ,1366x768@60,auto,auto
            '';
          };
  
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}