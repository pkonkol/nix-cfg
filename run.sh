#!/usr/bin/env bash
sudo nixos-rebuild switch --flake .#nixos-virt
home-manager switch --flake .#freiherr@nixos-virt
