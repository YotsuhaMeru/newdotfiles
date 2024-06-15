{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services = {
    # Enable the X11 windowing system.
    xserver.enable = true;

    dbus.enable = true;

    xserver.displayManager = {
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
}
