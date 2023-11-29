{pkgs, ...}:
{
  wayland.windowManager.hyprland.extraConfig = ''
    # fix EGL issues
    # env = LD_LIBRARY_PATH,${pkgs.libGL}/lib
  '';
}
