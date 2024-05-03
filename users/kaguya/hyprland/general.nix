{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.enable = true;

  home.packages = with pkgs; [
    swaynotificationcenter
    (nerdfonts.override {fonts = ["Ubuntu"];})
  ];
  xdg.configFile."swaync/style.css".source = pkgs.fetchurl {
    url = "https://github.com/catppuccin/swaync/releases/download/v0.1.2.1/mocha.css";
    sha256 = "19z41gvds15av1wpidzli1yqbm70fmdv04blr23ysbl944jvfvnv";
  };

  wayland.windowManager.hyprland.extraConfig = ''
    # exec-once = /etc/nixos/hosts/Mochizuki/init.sh
    general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5
        gaps_out = 20
        border_size = 4
        col.active_border = rgb(f5c2e7)
        col.inactive_border = rgb(6c7086)

        layout = dwindle
    }

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more

    # Source a file (multi-file configs)
    # source = ~/.config/hypr/myColors.conf

    # unscale XWayland
    xwayland {
      force_zero_scaling = true
    }

    dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = yes # you probably want this
    }

    master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true
    }

    gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = off
    }

    misc {
      enable_swallow = true
      swallow_regex = ^(kitty)$
    }

    input {
      kb_layout = jp
    }

  '';
}
