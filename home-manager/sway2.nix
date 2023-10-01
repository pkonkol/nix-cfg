{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    alacritty # gpu accelerated terminal
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer
    wdisplays # tool to configure displays
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      terminal = "alacritty";
      menu = "wofi --show run";

      #bars = [
      #  {
      #    fonts.size = 15.0;
      #    postition = "bottom";
      #  }
      #];
      output = {
        eDP-1 = {
          scale = "1";
        };
      };
    };
  };
  #security.pam.services.swaylock = {
  #  text = "auth include login";
  #};
}
