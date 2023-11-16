{
  lib,
  pkgs,
  config,
  ...
}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.dbus.enable = true;

  services.xserver.displayManager = {
    sddm = {
      enable = true;
      enableHidpi = false;
      autoNumlock = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
    };
    defaultSession = "hyprland";
    sessionPackages = [pkgs.hyprland];
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
  ];


  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
