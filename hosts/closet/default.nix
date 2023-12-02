{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  globals,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel

    ../common/global
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  users.mutableUsers = true; # this leads to resetting passwords on false
  users.users.root.initialHashedPassword = "$y$j9T$mJM1hfZT7rxiIl1yXOyGD1$ZVgPYR2ADNOzBbUMqFtA8M6Ms0SuvEr7AILl8vTuvoA";

  networking.hostName = "closet";
  networking.networkmanager.enable = true;

  virtualisation = {
    docker.enable = true;
  };

  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/vda";
  #boot.loader.grub.useOSProber = true;

  programs.fish.enable = true;
  users.users = {
    freiherr = {
      initialPassword = "changeme";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFtOoE+UsKcjaWezmo7tIQnRjbO6D0MxVug5gCr15u1LYrE1Sxc0YjmR+6hqmX+0NiQEntbSBscTEbcjsl7TaaO70HKQqgcQ1Wq0BFzrXN/FrZKE1gWHR/dreupqNVkOIxTuXt6kr8vJ8fgh9NH9phQr9TWUt+YIj5f7d8883NkD1LUW+OI6IoE7rJPVd0vjJfMRQHrqFXzSrkymTcuciAqzJnnMMQQQe/VgWoTlH6s828UcWSDUa63/IxdLWoV2k2IcKMS18E7eFxeXZNU6z0ritP05auWUSMa0nm/Az4ptrqopW9C2G0biY8NVOUwk4DgKxXppniEOnR70wua5zYeUETSYo5TvvahQd621bttLSEf65CHFgceGy91tNmDOTTG8NM9Msil8i/x6tWKpiJZzWn1W25SZpaQmHGdLwDrwWFU21SgGMnT8LjfsU4cBu3JFkwQ59JyEqKmp/Nqdjp70UyLxxPiLpDmfSVFtHYA/p5ikAxLncRE+Bmq5R3Cz8="
      ];
      extraGroups = ["wheel" "video" "audio" "docker" "networkmanager" "pipewire" "i2c"];
    };
    homelab = {
      initialPassword = "changeme";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFtOoE+UsKcjaWezmo7tIQnRjbO6D0MxVug5gCr15u1LYrE1Sxc0YjmR+6hqmX+0NiQEntbSBscTEbcjsl7TaaO70HKQqgcQ1Wq0BFzrXN/FrZKE1gWHR/dreupqNVkOIxTuXt6kr8vJ8fgh9NH9phQr9TWUt+YIj5f7d8883NkD1LUW+OI6IoE7rJPVd0vjJfMRQHrqFXzSrkymTcuciAqzJnnMMQQQe/VgWoTlH6s828UcWSDUa63/IxdLWoV2k2IcKMS18E7eFxeXZNU6z0ritP05auWUSMa0nm/Az4ptrqopW9C2G0biY8NVOUwk4DgKxXppniEOnR70wua5zYeUETSYo5TvvahQd621bttLSEf65CHFgceGy91tNmDOTTG8NM9Msil8i/x6tWKpiJZzWn1W25SZpaQmHGdLwDrwWFU21SgGMnT8LjfsU4cBu3JFkwQ59JyEqKmp/Nqdjp70UyLxxPiLpDmfSVFtHYA/p5ikAxLncRE+Bmq5R3Cz8="
      ];
      extraGroups = ["wheel" "video" "audio" "docker" "sway" "pipewire" "i2c"];
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  environment.systemPackages = with pkgs; [ 
    neovim
    ranger
    tmux
    nixpkgs-fmt 
  ];

  system.stateVersion = "24.05";

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
