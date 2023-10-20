{
  config,
  pkgs,
  ...
}: {
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
      XMODIFIERS = "@im=fcitx";
      XMODIFIER = "@im=fcitx";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      DefaultIMModule = "fcitx";
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
  programs = {
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
      patches =
        (oa.patches or [])
        ++ [
          (pkgs.fetchpatch {
            name = "fix waybar hyprctl";
            url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
            sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
          })
        ];
    });
    systemd.enable = true;
    settings = [
      {
        "layer" = "top";
        "position" = "bottom";
        "height" = 30;
        "width" = 1280;
        "spacing" = 4;
        "modules-left" = ["wlr/workspaces"];
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

                                            #clock,
                                                #network,
                                                    #temperature,
                                                        #cpu,
                                                            #memory,
                                                                #pulseaudio,
                                                                    #tray,
                                                                        #workspaces button,
                                                                            #battery {
                                                                                    background-color: #fcc0e3;
                                                                                          color: #111111;
                                                                                                border-radius: 10px;
                                                                                                      margin-top: 7px;
                                                                                                            padding-left: 4px;
                                                                                                                  padding-right: 4px;
                                                                                                                        margin-right: 6px;
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
