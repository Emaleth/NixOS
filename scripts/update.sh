#!/bin/sh
sudo nix flake update /home/emaleth/Repositories/NixOS
sudo nixos-rebuild switch --flake /home/emaleth/Repositories/NixOS --impure