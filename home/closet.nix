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
    ./features/syncthing.nix

    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    # Or modules exported from other flakes (such as nix-colors):
    #inputs.nix-colors.homeManagerModules.default
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
