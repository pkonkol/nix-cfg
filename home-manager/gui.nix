{
  # GUI SHIT

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
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  #wayland.windowManager.sway = {
  #  enable = true;
  #  config = rec {
  #    modifier = "Mod4";
  #    # Use kitty as default terminal
  #    terminal = "kitty"; 
  #    startup = [
  #      # Launch Firefox on start
  #      {command = "firefox";}
  #    ];
  #  };
  #};

  #wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    config = {
      #startup = [
      #  # https://github.com/NixOS/nixpkgs/issues/119445
      #  {command = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
      #];
      terminal = "alacritty";
      menu = "wofi --show run";
      fonts = {
        names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
        style = "Bold Semi-Condensed";
        size = 12.0;
      }
      #output = {
      #  eDP-1 = {
      #    scale = "1";
      #  };
      #};
    };
  };

}
