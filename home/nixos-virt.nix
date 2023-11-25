{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  globals,
  ...
}: let
  huj = builtins.trace "huj1234" "";
in {
  imports = [
    ./features/cli.nix
    ./features/gui.nix
    ./features/syncthing.nix

    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    # Or modules exported from other flakes (such as nix-colors):
    #inputs.nix-colors.homeManagerModules.default
  ];
  # shit didnt work fuck
  #globals = import ./globals.nix;

  home = {
    username = "freiherr";
    homeDirectory = "/home/freiherr";
  };

  home.packages = with pkgs; [
    nix-output-monitor
    ddcutil
  ];

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
      # You can also add overlays exported from other flakes: neovim-nightly-overlay.overlays.default Or define it inline, for example:
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
      # allowUnfreePredicate = _: true;
    };
  };
}
