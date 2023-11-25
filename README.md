# Personal configuration for 

# usage

`nix develop` to start devShell (**NOT NIX SHELL**)
`nixos-rebuild --flake .#pc`
`home-manager --flake .#freiherr@pc`

## iso installer
works even on arch with just nix
`nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix`

## home-manager on non-nixos systems
TODO how to deploy this on ubuntu

# machines

## pc
Main work machine

## closet
HP elitedesk 800 g2 used as a server

## nixos-virt
libvirtd virtual machine

## todo later
- laptop
- vbox
- rpi
