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
  };

  services.dbus.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

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
    kitty
  ];
}
