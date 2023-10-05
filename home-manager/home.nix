# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./cli.nix
    ./gui.nix
    #./sway.nix
    #./sway2.nix
    # not working through home manager?
    #./services.nix
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here: ./nvim.nix
  ];

  home = {
    username = "freiherr";
    homeDirectory = "/home/freiherr";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # cli basic
    wget
    vim
    git
    ranger
    tmux
    exa
    jq
    bat
    zoxide
    fzf
    grc
    yq-go
    jc
    ripgrep
    fd
    sd
    inxi 
    file
    which
    gnused
    gnutar
    gawk
    zstd
    # archives
    zip xz unzip p7zip
    # network
    mtr iperf3 dnsutils ldns aria2 socat nmap ipcalc
    # cli extra
    glow
    btop
    iotop
    iftop
    # gui base
    libnotify
    waybar
    dunst
    swww
    rofi-wayland
    wofi
    seatd
    # gui tools
    chromium
    kitty
    alacritty
    telegram-desktop
    # nix
    nix-output-monitor
  ];


  services.syncthing = {
    enable = true;
  };


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };
}
