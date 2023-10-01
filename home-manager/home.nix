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

  home = {
    username = "freiherr";
    homeDirectory = "/home/freiherr";
  };

  home.shellAliases = rec {
    e = "nvim";
    g = "git";
    l = "exa";
    t = tree;
    tree = "exa -T";
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
    ripgrep
    fd
    sd
    inxi 
    # gui base
    libnotify
    waybar
    dunst
    swww
    rofi-wayland
    # gui tools
    chromium
    kitty
    alacritty
    telegram-desktop
  ];

  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # CLI SETTINGS

  programs.git = {
    enable = true;
    userName = "Piotr Konkol";
    userEmail = "piotrkonkol01@gmail.com";
    aliases = {
      lg = "log --all --graph --decorate --oneline";
      ci = "commit";
      co = "checkout";
      s = "status";
      b = "branch";
      p = "pull --rebase";
      pu = "push";
    };
    extraConfig = {
      core.editor = "nvim";
    };
  };

  programs = {
    bat.enable = true;
    zoxide.enable = true;
    jq.enable = true;
    htop.enable = true;
    tealdeer.enable = true;
    ncmpcpp.enable = true;
    mpv.enable = true;
  };

  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };
  programs.starship = {
    enable = true;
    settings = {};
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      # conflicts with starship prompt
      #{ name = "async-prompt"; src = pkgs.fishPlugins.async-prompt.src; }
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
    ];
    shellAbbrs = {
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      ip = "ip -color=auto";
      diff = "diff --color=auto";
    };
    shellInit = ''
      fish_vi_key_bindings
    '';
  };

  programs.atuin = {
    enable = false;
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.gruvbox
      pkgs.tmuxPlugins.tmux-fzf
      # TODO how to add srcery-tmux here? is tpm still needed?
    ];
    keyMode = "vi";
    #terminal = "alacritty";
    historyLimit = 10000;
    newSession = true;
    clock24 = true;
    extraConfig = ''
      set-option -g mouse on
      setw -g mode-keys vi
      set -g default-terminal "tmux-256color"
    '';
    # bind-key v split-window -h
    # bind-key s split-window -v
    # bind-key h select-pane -L
    # bind-key j select-pane -D
    # bind-key k select-pane -U
    # bind-key l select-pane -R
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      terminus
      gruvbox
      srcery-vim
      (nvim-treesitter.withPlugins (_:pkgs.tree-sitter.allGrammars))
      nvim-web-devicons
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup()
        '';
      }
      vim-nix
      vim-markdown
      vim-tmux-navigator
      vim-tmux
    ];
    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./neovim.lua}
      EOF
    '';
  };

  # GUI SHIT

  programs.kitty = {
    enable = true;
    # srcery is in themes.json but suppsedly not in kitty-themes
    theme = "Gruvbox Dark";
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
