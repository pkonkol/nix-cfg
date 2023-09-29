#!/usr/bin/bash

nixos-rebuild switch --flake .#nixos-vbox
home-manager switch --flake .#freiherr@nixos-vbox
