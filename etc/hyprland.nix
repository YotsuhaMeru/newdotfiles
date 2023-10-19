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
  environment.systemPackages = [
    pkgs.nur.repos.MtFBella109.catppuccin-mocha
  ];
}
