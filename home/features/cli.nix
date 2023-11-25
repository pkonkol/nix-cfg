{
  pkgs,
  globals,
  ...
}: {
  home.shellAliases = rec {
    e = "nvim";
    g = "git";
    la = "exa -a";
  };

  home.packages = with pkgs; [
    # cli basic
    wget
    vim
    ranger
    tmux
    pkgs.unstable.eza
    #exa
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
    neofetch
    # archives
    zip
    xz
    unzip
    p7zip
    # network
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc
    # cli extra
    glow
    btop
    iotop
    iftop
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
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
      credential.helper = "cache";
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
    go.enable = true;
    chromium.enable = true;
    firefox.enable = true;
  };

  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };

  # TODO change to eza, but home-manager has it on master not release-23.05
  programs.exa = {
    package = pkgs.unstable.eza;
    enable = true;
    git = true;
    icons = true;
    enableAliases = true;
    #extraOptions = {};
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
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
      #ip = "ip -color=auto";
      #diff = "diff --color=auto";
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
      (nvim-treesitter.withPlugins _:pkgs.tree-sitter.allGrammars)
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
      ${builtins.readFile ./cli/neovim.lua}
      EOF
    '';
  };
}
