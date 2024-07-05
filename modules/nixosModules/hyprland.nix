{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hyprland;
in {
  options = {
    modules.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    services = {
      dbus.enable = true;

      displayManager = {
        sddm = {
          enable = true;
          enableHidpi = false;
          autoNumlock = true;
          wayland.enable = true;
          theme = "catppuccin-mocha";
        };
        defaultSession = "hyprland";
        autoLogin.user = config.var.username;

        sessionPackages = [pkgs.hyprland];
      };
    };

    environment.systemPackages = with pkgs; [
      pkgs.nur.repos.MtFBella109.catppuccin-mocha
      wofi
      gnome.nautilus
      kitty
      wl-clipboard
      grim
      slurp
      at-spi2-core
      qt5.qtwayland
      qt6.full
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];

    xdg.portal.enable = true;
  };
}
