{pkgs, ...}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "merutan1392";
    homeDirectory = "/home/merutan1392";
    packages = with pkgs; [
      nitch
      dolphin
      pavucontrol
      mako
      pipewire
      wireplumber
    ];
    sessionVariables = {
      LC_ALL = "ja_JP.UTF-8";
      TZ = "Asia/Tokyo";
      EDITOR = "vim";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      autogenerated = 0
      exec-once = /etc/nixos/hosts/NixbookAir/init.sh
      exec-once = dbus-update-activation-environment --systemd --all
      exec-once = systemctl --user start hyprland-session.target
      monitor = ,1366x768@60,auto,auto
      env = XCURSOR_SIZE,24
      env = GTK_IM_MODULE, fcitx
      env = QT_IM_MODULE, fcitx
      env = XMODIFIERS, @im=fcitx
      input {
        kb_layout = jp
        kb_model = jp106
        follow_mouse = 1
        touchpad {
          natural_scroll = no
        }
        sensitivity = 0
      }
      general {
        gaps_in = 5
        gaps_out = 20
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
        layout = dwindle
      }
      animations {
        enabled = yes
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }
      dwindle {
        pseudotile = yes
        preserve_split = yes
      }
      master {
        new_status = master
      }
      gestures {
        workspace_swipe = off
      }

      windowrulev2 = opacity 0.80 0.80,class:^(kitty)$
      windowrulev2 = opacity 0.90 0.90,class:^(emacs)$

      $mainMod = SUPER
      bind = $mainMod, Q, exec, kitty
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, dolphin
      bind = $mainMod, R, exec, wofi --show drun

      binde =, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
      binde =, XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
      bind =, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5

      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5

      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      bindm = $mainMod, mouse:272, movewindow
    '';
  };
  programs = {
    direnv = {
      enable = true;
      nix-direnv = {enable = true;};
    };
    fish = {
      enable = true;
      shellAliases = {
        "cd.." = "cd ..";
        "lsal" = "ls -al";
        "...." = "cd ../..";
      };
      #shellInit = "~/.nix-profile/etc/profile.d/hm-session-vars.sh";
    };
    home-manager.enable = true;

    vim = {
      enable = true;
      extraConfig = ''
        :set encoding=utf-8
                :set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
                        :set fileformats=unix,dos,mac
      '';
    };
    alacritty = {
      enable = true;
      settings = {
        shell.program = "${pkgs.fish}/bin/fish";
        colors = {
          primary = {
            background = "0x282a36";
            foreground = "0xf8f8f2";
            bright_foreground = "0xffffff";
          };
          cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          vi_mode_cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          search = {
            matches = {
              foreground = "0x44475a";
              background = "0xf8f8f2";
            };
            focused_match = {
              foreground = "#44475a";
              background = "#ffb86c";
            };
          };
          footer_bar = {
            background = "#282a36";
            foreground = "#f8f8f2";
          };
          hints = {
            start = {
              foreground = "#282a36";
              background = "#f1fa8c";
            };
            end = {
              foreground = "#f1fa8c";
              background = "#282a36";
            };
          };
          line_indicator = {
            foreground = "None";
            background = "None";
          };
          selection = {
            text = "CellForeground";
            background = "#44475a";
          };
          normal = {
            black = "#21222c";
            red = "#ff5555";
            green = "#50fa7b";
            yellow = "#f1fa8c";
            blue = "#bd93f9";
            magenta = "#ff79c6";
            cyan = "#8be9fd";
            white = "#f8f8f2";
          };
          bright = {
            black = "#6272a4";
            red = "#ff6e6e";
            green = "#69ff94";
            yellow = "#ffffa5";
            blue = "#d6acff";
            magenta = "#ff92df";
            cyan = "#a4ffff";
            white = "#ffffff";
          };
        };
        hide_cursor_when_typing = true;
        font.size = 7.0;
      };
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: [
      epkgs.vterm
    ];
  };
  programs.wofi = {
    enable = true;
  };
  programs.chromium = {
    enable = true;
    commandLineArgs = ["--high-dpi-support=1"];
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
    systemd.enable = true;
    settings = [
      {
        "layer" = "top";
        "position" = "bottom";
        "height" = 30;
        "width" = 1280;
        "spacing" = 4;
        "modules-left" = ["hyprland/workspaces"];
        "modules-center" = ["hyprland/window"];
        "modules-right" = ["pulseaudio" "network" "temperature" "battery" "clock" "tray"];
        "keyboard-state" = {
          "numlock" = true;
          "capslock" = true;
          "format" = "{name} {icon}";
          "format-icons" = {
            "locked" = "";
            "unlocked" = "";
          };
        };
        "tray" = {
          "spacing" = 10;
        };
        "clock" = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        "temperature" = {
          "critical-threshold" = 80;
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = ["" "" ""];
        };
        "cpu" = {
          "format" = "{usage}% ";
          "tooltip" = false;
        };
        "memory" = {
          "format" = "{}% ";
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = ["" "" "" "" ""];
        };
        "network" = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };
        "pulseaudio" = {
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          "on-click" = "pavucontrol";
        };
      }
    ];
    style = ''
      * {
        font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(43, 48, 59, 0.5);
      }

      #workspaces button {
        background-color: #fed9ee;
        color: #111111;
        border-radius: 10px;
        padding-left: 4px;
        padding-right: 4px;
      }

      #clock,
      #network,
      #temperature,
      #cpu,
      #memory,
      #pulseaudio,
      #tray,
      #window,
      #battery {
        background-color: #fed9ee;
        color: #111111;
        border-radius: 10px;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 7px;
        padding-right: 7px;
      }
    '';
  };
  programs.kitty = {
    enable = true;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };
}
