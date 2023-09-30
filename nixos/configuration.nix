# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
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

    ./vbox.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

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
  };

  networking.hostName = "nixos-vbox";

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  #boot.loader.systemd-boot.enable = true;
  #grub?
  boot.loader.grub.device = "/dev/sda";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    freiherr = {
      initialPassword = "changeme";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFtOoE+UsKcjaWezmo7tIQnRjbO6D0MxVug5gCr15u1LYrE1Sxc0YjmR+6hqmX+0NiQEntbSBscTEbcjsl7TaaO70HKQqgcQ1Wq0BFzrXN/FrZKE1gWHR/dreupqNVkOIxTuXt6kr8vJ8fgh9NH9phQr9TWUt+YIj5f7d8883NkD1LUW+OI6IoE7rJPVd0vjJfMRQHrqFXzSrkymTcuciAqzJnnMMQQQe/VgWoTlH6s828UcWSDUa63/IxdLWoV2k2IcKMS18E7eFxeXZNU6z0ritP05auWUSMa0nm/Az4ptrqopW9C2G0biY8NVOUwk4DgKxXppniEOnR70wua5zYeUETSYo5TvvahQd621bttLSEf65CHFgceGy91tNmDOTTG8NM9Msil8i/x6tWKpiJZzWn1W25SZpaQmHGdLwDrwWFU21SgGMnT8LjfsU4cBu3JFkwQ59JyEqKmp/Nqdjp70UyLxxPiLpDmfSVFtHYA/p5ikAxLncRE+Bmq5R3Cz8="
      ];
      extraGroups = ["wheel" "docker"];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    settings.PermitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    settings.PasswordAuthentication = false;
  };

  time.timeZone = "Europe/Warsaw";

  environment.systemPackages = with pkgs; [
    wget vim neovim git ranger tmux home-manager
    waybar dunst libnotify swww rofi-wayland chromium
    kitty alacritty
  ];

  # also conflicts with gnome
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  sound.enable = true;
  security.rtkit.enable = true;
  # conflicts with gnome
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  jack.enable = true;
  #};
  # didn't boot up, got stuck
  services.greetd.enable = false;
  services.xserver.enable = true;
  #services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.hyprland = { 
    enable = true;
    xwayland.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
