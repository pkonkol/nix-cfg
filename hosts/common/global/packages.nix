{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pkgs.unstable.nil
    home-manager
    neovim
    wget
    gitAndTools.gitFull
    killall
    ranger
    tmux
    fish
    xorg.xrandr
    wlr-randr
    parted
    acpi
    sysstat
    lm_sensors
    neofetch
    unzip
    tealdeer
    htop
  ];
}
