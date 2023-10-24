{
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = waybar
    exec-once = hyprpaper
    exec-once = fcitx5
    exec-once = swaync
  '';
}
