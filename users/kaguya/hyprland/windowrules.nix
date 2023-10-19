{
  wayland.windowManager.hyprland.extraConfig = ''
    # Example windowrule v1
    # windowrule = float, ^(kitty)$
    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

    windowrulev2 = opacity 0.80 0.80,class:^(kitty)$
    windowrulev2 = opacity 0.80 0.80,class:^(emacs)$
    windowrulev2 = opacity 0.80 0.80,class:^(pavucontrol)$
  '';
}
