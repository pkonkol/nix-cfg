{ pkgs, config, lib, ...}:
let 
  inherit (config.colorscheme) colors;
in {
  imports = [
    ./gui/files.nix
    ./vars.nix
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
  ];

  programs = {
    tealdeer.enable = true;
    ncmpcpp.enable = true;
    mpv.enable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music" ;
  };

  programs.kitty = {
    enable = true;
    # srcery is in themes.json but suppsedly not in kitty-themes
    theme = "Gruvbox Dark";
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
        offset.y = 2;
        draw_bold_text_with_bright_colors = true;
        live_config_reload = true;
      };
      scrolling.history = 10000;
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
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
          { # doesn't work despite mpd working TODO
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
              { display = " -&gt; Sleep &lt;-"; cmd = "systemctl suspend"; }
              { display = " -&gt; Power off &lt;-"; cmd = "poweroff"; confirm_msg = "are you sure?"; }
              { display = " -&gt; Reboot &lt;-"; cmd = "reboot"; confirm_msg = "are you sure?"; }
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
        names = [ "Terminus" "Terminus (TTF)" ]; #"DejaVu Sans Mono" ];
        style = "Regular";
        size = 10.0;
      };
      startup = [
        #{ command = "sh -c \"killall yambar; yambar &\""; always = true; }
        { command = "alacritty"; }
      ];
      window = {
        border = 1;
        hideEdgeBorders = "smart";
        titlebar = false;
      };
      output = {
        Virtual-1 = {
          mode = "1200x1300";
        };
      };
      bars = [ 
        {
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.home.homeDirectory}/.config/i3status-rust/config-default.toml";
        }
      ];
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        "${modifier}+x" = "kill";
        "${modifier}+bracketleft" = "exec --no-startup-id grimshot --notify  save area /tmp/scrot-$(date \"+%Y-%m-%d\"T\"%H:%M:%S\").png";
        "${modifier}+bracketright" = "exec --no-startup-id grimshot --notify  copy area";
        "${modifier}+Shift+Ctrl+l" = "exec loginctl lock-session";
        "XF86MonBrightnessDown" = "exec ddcutil -d 1 '- 10'";
        "XF86MonBrightnessUp" = "exec ddcutil -d 1 '+ 10'";
        "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
        "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
        "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
      };
      # TODO
      #assigns = { "1: web" = [{ class = "^Firefox$"; }]; };
      colors = {};
      # add brightess control here?
      #keycodebindings = {};
      # modifier= "";
      #bars = [{
      #  position = "top";
      #  statusCommand = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";
      #  colors = {
      #    statusline = "#ffffff";
      #    background = "#323232";
      #    inactiveWorkspace = {
      #      border = "#32323200";
      #      background = "#32323200";
      #      text = "#5c5c5c";
      #    };
      #  };
      #}];        
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Terminus 12";
    location = "top-left";
    terminal = "alacritty";
    theme = "srcery_rofi.rasi";
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      color = "1c1b19";
      font-size = 24;
      line-color = "ffffff";
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
            mode = "1200x1300";
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
  };

  systemd.user.services.autotiling = {
    Install = {
      WantedBy = [ "sway-session.target" ];
      PartOf = [ "graphical-session.target" ];
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
