{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  globals,
  ...
}: 
{
  imports = [
    ./features/cli.nix
    ./features/gui.nix
    ./features/syncthing.nix
  ];

  home = {
    username = "freiherr";
    homeDirectory = "/home/freiherr";
  };

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
