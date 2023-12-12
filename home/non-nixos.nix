{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  globals,
  ...
}: let
  username = "user";
in {
  imports = [
    ./features/cli.nix
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  home.packages = with pkgs; [
    nix-output-monitor
  ];

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      # allowUnfreePredicate = _: true;
    };
  };
}
