#!/bin/sh
cd
cd Repositories/NixOS
sudo nix flake update
cd
sudo nixos-rebuild switch --flake /home/emaleth/Repositories/NixOS --impure
