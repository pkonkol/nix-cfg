#!/usr/bin/env bash
sudo nixos-rebuild switch --flake .#changeme --impure # TODO get rid of the impure
home-manager switch --flake .#freiherr@changeme
