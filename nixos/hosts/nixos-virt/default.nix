# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  globals,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../common/global
    ../common/optional/greetd.nix
    ../common/optional/sound.nix
    ./hardware-configuration.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  hardware.i2c.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.hostName = "nixos-virt";
  networking.networkmanager.enable = true;
  #networking.useDHCP = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  programs.fish.enable = true;
  users.users = {
    freiherr = {
      initialPassword = "changeme";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFtOoE+UsKcjaWezmo7tIQnRjbO6D0MxVug5gCr15u1LYrE1Sxc0YjmR+6hqmX+0NiQEntbSBscTEbcjsl7TaaO70HKQqgcQ1Wq0BFzrXN/FrZKE1gWHR/dreupqNVkOIxTuXt6kr8vJ8fgh9NH9phQr9TWUt+YIj5f7d8883NkD1LUW+OI6IoE7rJPVd0vjJfMRQHrqFXzSrkymTcuciAqzJnnMMQQQe/VgWoTlH6s828UcWSDUa63/IxdLWoV2k2IcKMS18E7eFxeXZNU6z0ritP05auWUSMa0nm/Az4ptrqopW9C2G0biY8NVOUwk4DgKxXppniEOnR70wua5zYeUETSYo5TvvahQd621bttLSEf65CHFgceGy91tNmDOTTG8NM9Msil8i/x6tWKpiJZzWn1W25SZpaQmHGdLwDrwWFU21SgGMnT8LjfsU4cBu3JFkwQ59JyEqKmp/Nqdjp70UyLxxPiLpDmfSVFtHYA/p5ikAxLncRE+Bmq5R3Cz8="
      ];
      extraGroups = ["wheel" "video" "audio" "docker" "sway" "networkmanager" "pipewire" "i2c"];
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = true;
  };
  services.printing.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
    alejandra
    nixfmt
    ddcutil
    scrot
    xfce.thunar
  ];

  fonts.fonts = with pkgs; [
    terminus_font
    terminus_font_ttf
    (nerdfonts.override {fonts = ["Terminus" "JetBrainsMono" "Noto" "FiraCode"];})
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    material-design-icons
    font-awesome
  ];
  fonts.enableDefaultFonts = false;
  fonts.fontconfig.defaultFonts = {
    serif = ["Noto Serif" "Noto Color Emoji"];
    sansSerif = ["Noto Sans" "Noto Color Emoji"];
    monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
    emoji = ["Noto Color Emoji"];
  };

  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  #services.xserver.enable = true;
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.displayManager.gdm.enable = false;
  #services.xserver.desktopManager.gnome.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };

  programs.sway.enable = true;
  #programs.hyprland.enable = true;

  system.stateVersion = "23.05";

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
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
