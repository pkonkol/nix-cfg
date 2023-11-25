{
  pkgs,
  config,
  lib,
  globals,
  ...
}: {
  imports = [
    ./gui/files.nix
  ];
  home.packages = with pkgs; [
    # gui base
    libnotify
    seatd
    xdragon
    wdisplays
    # gui tools
    pavucontrol
    chromium
    kitty
    alacritty
    telegram-desktop
    zathura
    # SWAY
    bemenu
    #rofi-wayland
    swww
    swaylock-effects
    swayidle
    wl-clipboard
    mako
    yambar
    autotiling-rs
    gammastep
    sway-contrib.grimshot
    kanshi
    # hgmmm
    playerctl
  ];

  programs = {
    tealdeer.enable = true;
    ncmpcpp.enable = true;
    mpv.enable = true;
  };

  services = {
    playerctld.enable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
  };

  programs.chromium = {
    enable = true;
    extensions = [
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # Vimium
      {id = "oboonakemofpalcgghocfoadofidjkkk";} # KeePassXC-Browser
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # Ublock Origin
      {id = "gcbommkclmclpchllfjekcdonpmejbdp";} # HTTPS everywhere
      {id = "mmpokgfcmbkfdeibafoafkiijdbfblfg";} # Merge windows
      {id = "agldajbhchobfgjcmmigehfdcjbmipne";} # Blank Dark New Tab
    ];
  };

  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 10;
        normal = {
          family = "Terminus";
          style = "Regular";
        };
        opacity = 0.85;
        padding = {
          x = 1;
          y = 1;
        };
        offset.y = 2;
        draw_bold_text_with_bright_colors = true;
        live_config_reload = true;
      };
      scrolling.history = 10000;
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      cursor = {style = "Beam";};
      colors = with globals.colors; {
        primary = {
          background = "0x${black}";
          foreground = "0x${brightwhite}";
        };
        cursor = {
          text = "0x${black}";
          cursor = "0x${yellow}";
        };
        normal = {
          black = "0x${black}";
          red = "0x${red}";
          green = "0x${green}";
          yellow = "0x${yellow}";
          blue = "0x${blue}";
          magenta = "0x${magenta}";
          cyan = "0x${cyan}";
          white = "0x${white}";
        };
        bright = {
          black = "0x${brightblack}";
          red = "0x${brightred}";
          green = "0x${brightgreen}";
          yellow = "0x${brightyellow}";
          blue = "0x${brightblue}";
          magenta = "0x${brightmagenta}";
          cyan = "0x${brightcyan}";
          white = "0x${brightwhite}";
        };
      };
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            block = "focused_window";
            driver = "wlr_toplevel_management";
            format = {
              full = " $title.str(max_w:30) | Missing ";
              short = " $title.str(max_w:15) | Missing ";
            };
          }
          {
            # doesn't work despite mpd working TODO
            block = "music";
            player = "mdp";
            click = [
              {
                button = "left";
                action = "play_pause";
              }
            ];
          }
          {
            alert = 10.0;
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            warning = 20.0;
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
            format_alt = " $icon $swap_used_percents ";
          }
          #{ block = "amd_gpu"; }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            format = " $icon $1m ";
            interval = 1;
          }
          #{ block = "bluetooth"; }
          {
            block = "net";
            format = "$icon $device:$ip ";
          }
          {
            block = "external_ip";
          }
          {
            block = "sound";
            driver = "auto";
          }
          # this may support ddcutil, this would help a lot
          #{ block = "backlight"; }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            interval = 60;
          }
          {
            block = "menu";
            text = "|power";
            items = [
              {
                display = " -&gt; Sleep &lt;-";
                cmd = "systemctl suspend";
              }
              {
                display = " -&gt; Power off &lt;-";
                cmd = "poweroff";
                confirm_msg = "are you sure?";
              }
              {
                display = " -&gt; Reboot &lt;-";
                cmd = "reboot";
                confirm_msg = "are you sure?";
              }
            ];
          }
        ];
        #settings = {
        #  theme = {
        #    theme = "srcery";
        #  };
        #};
        icons = "material-nf";
        theme = "srcery";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    config = {
      workspaceAutoBackAndForth = true;
      terminal = "alacritty";
      #menu = "bemenu-run --binding vim -i";
      menu = "rofi -show combi";
      fonts = {
        names = ["Terminus" "Terminus (TTF)"]; #"DejaVu Sans Mono" ];
        style = "Regular";
        size = 10.0;
      };
      startup = [
        #{ command = "sh -c \"killall yambar; yambar &\""; always = true; }
        {command = "alacritty";}
      ];
      window = {
        border = 1;
        hideEdgeBorders = "smart";
        titlebar = false;
      };
      output = {
        Virtual-1 = {
          mode = "${globals.defaultResolution}";
        };
      };
      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.home.homeDirectory}/.config/i3status-rust/config-default.toml";
          colors = {
            statusline = "#${globals.colors.white}";
            background = "#${globals.colors.black}";
            separator = "#${globals.colors.yellow}";
            inactiveWorkspace = {
              border = "#${globals.colors.brightblack}";
              background = "#${globals.colors.xgray2}";
              text = "#${globals.colors.white}";
            };
            activeWorkspace = {
              border = "#${globals.colors.yellow}";
              background = "#${globals.colors.black}";
              text = "#${globals.colors.yellow}";
            };
            focusedWorkspace = {
              border = "#${globals.colors.red}";
              background = "#${globals.colors.black}";
              text = "#${globals.colors.yellow}";
            };
            urgentWorkspace = {
              border = "#${globals.colors.red}";
              background = "#${globals.colors.black}";
              text = "#${globals.colors.red}";
            };
            bindingMode = {
              border = "#${globals.colors.green}";
              background = "#${globals.colors.black}";
              text = "#${globals.colors.white}";
            };
          };
        }
      ];
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "${modifier}+x" = "kill";
          "${modifier}+Shift+Escape" = "exec xkill";
          "${modifier}+bracketleft" = "exec --no-startup-id grimshot --notify  save area /tmp/scrot-$(date \"+%Y-%m-%d\"T\"%H:%M:%S\").png";
          "${modifier}+bracketright" = "exec --no-startup-id grimshot --notify  copy area";
          "${modifier}+Shift+Ctrl+l" = "exec loginctl lock-session";
          "XF86MonBrightnessDown" = "exec ddcutil -d 1 '- 10'";
          "XF86MonBrightnessUp" = "exec ddcutil -d 1 '+ 10'";
          "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
          "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
          "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioStop" = "exec playerctl stop";
          "Print" = "exec --no-startup-id grimshot --notify  save area /tmp/scrot-$(date \"+%Y-%m-%d\"T\"%H:%M:%S\").png";
        };
      colors = let
        c = globals.colors;
      in {
        focused = {
          background = "#${c.black}";
          border = "#${c.red}";
          childBorder = "#${c.brightred}";
          indicator = "#${c.yellow}";
          text = "#${c.yellow}";
        };

        focusedInactive = {
          background = "#${c.black}";
          border = "#${c.red}";
          childBorder = "#${c.brightred}";
          indicator = "#${c.brightyellow}";
          text = "#${c.white}";
        };

        unfocused = {
          background = "#${c.xgray2}";
          border = "#${c.orange}";
          childBorder = "#${c.brightorange}";
          indicator = "#${c.brightorange}";
          text = "#${c.white}";
        };

        urgent = {
          background = "#${c.hardblack}";
          border = "#${c.magenta}";
          childBorder = "#${c.brightmagenta}";
          indicator = "#${c.magenta}";
          text = "#${c.yellow}";
        };
      };
      # TODO
      #assigns = { "1: web" = [{ class = "^Firefox$"; }]; };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Terminus 12";
    location = "top-left";
    terminal = "alacritty";
    theme = "srcery_rofi.rasi";
    # TODO theme it directly here
    #theme = with globals.colors; {
    #  "window" = {
    #    background = "#${black}";
    #    foreground = "#${brightwhite}";
    #    separator = "#${blue}";
    #    border = 2;
    #  };
    #};
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = with globals.colors; {
      color = "${black}";
      line-color = "${white}";
      ring-color = "${green}";
      text-color = "${white}";
      inside-wrong-color = "${red}";
      bs-hl-color = "${magenta}";
      layout-text-color = "${white}";
      indicator-radius = 100;
      font-size = 24;
      font = "${globals.font}";
      deamonize = true;
      clock = true;
      ignore-empty-password = true;
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
    ];
  };

  services.kanshi = {
    enable = true;
    profiles = {
      virt = {
        outputs = [
          {
            criteria = "Virtual-1";
            status = "enable";
            mode = "${globals.defaultResolution}";
            position = "0,0";
          }
        ];
      };
    };
  };

  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    font = "Terminus 10";
    anchor = "top-right";
    backgroundColor = "#${globals.colors.black}";
    borderColor = "#${globals.colors.red}";
    textColor = "#${globals.colors.brightwhite}";
    borderRadius = 3;
    borderSize = 1;
    height = 200;
    width = 300;
    icons = true;
    margin = "10";
    padding = "5";
  };

  systemd.user.services.autotiling = {
    Install = {
      WantedBy = ["sway-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.autotiling-rs}/bin/autotiling-rs";
      Restart = "always";
      RestartSec = 5;
    };
  };

  services.gammastep = {
    enable = true;
    dawnTime = "6:00-8:00";
    duskTime = "20:00-22:00";
    latitude = 54.0;
    longitude = 18.0;
    temperature.day = 5000;
    temperature.night = 3200;
  };
  #services.wlsunset = {
  #  enable = true;
  #  latitude = "54.0";
  #  longitude = "18.0";
  #  temperature = {
  #    day = 4500;
  #    night = 3500;
  #  };
  #};
}
