{ pkgs, ...}:
{
  home.packages = with pkgs; [
    bemenu
  ];

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

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    config = {
      terminal = "alacritty";
      #menu = "bemenu-run --binding vim -i";
      menu = "rofi -show combi";
      fonts = {
        names = [ "Terminus" "Terminus (TTF)" ]; #"DejaVu Sans Mono" ];
        style = "Regular";
        size = 10.0;
      };
      output = {
        VGA-1 = {
          res = "1920x1080";
          scale = "1";
        };
      };
      bars = [{
        position = "top";
        statusCommand = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";
        colors = {
          statusline = "#ffffff";
          background = "#323232";
          inactiveWorkspace = {
            border = "#32323200";
            background = "#32323200";
            text = "#5c5c5c";
          };
        };
      }];        
    };
  };
  
  services.redshift = {
    enable = true;
    package = pkgs.gammastep;
    #extraOptions = ["-v" "-m" "wayland"];
    latitude = "54.0";
    longitude = "18.0";
    temperature = { 
      day = 4500;
      night = 3500;
    };
  };
}
