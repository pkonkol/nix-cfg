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
    ./features/cli.nix
    ./features/syncthing.nix
  ];

  programs.git.extraConfig = {
    safe.directory = "*";
  };

  home = {
    username = "freiherr";
    homeDirectory = "/home/freiherr";
  };

  # TODO change to actual 24.05
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      # allowUnfreePredicate = _: true;
    };
  };
}
