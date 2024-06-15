_: {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      autogenerated = 0
      monitor = ,1366x768@60,auto,auto
      $mainmod = SUPER
      bind = $mainmod, C, killactive
      bind = $mainmod, M, exit
      bind = $mainmod, R, exec, wofi --show drun
      bind = $mainmod, 1, workspace, 1
      bind = $mainmod, 2, workspace, 2
      bind = $mainmod, 3, workspace, 3
      bind = $mainmod, 4, workspace, 4
      bind = $mainmod, 5, workspace, 5
      bind = $mainmod SHIFT, 1, movetoworkspace, 1
      bind = $mainmod SHIFT, 2, movetoworkspace, 2
      bind = $mainmod SHIFT, 3, movetoworkspace, 3
      bind = $mainmod SHIFT, 4, movetoworkspace, 4
      bind = $mainmod SHIFT, 5, movetoworkspace, 5

      bindm = $mainmod, mouse:272, movewindow
    '';
  };
}
