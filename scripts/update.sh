#!/bin/sh
echo updating flake inputs
sudo nix flake update /home/emaleth/Repositories/NixOS >/dev/null 2>&1
echo updating system
sudo nixos-rebuild switch --flake /home/emaleth/Repositories/NixOS --impure >/dev/null 2>&1
echo post-update cleanup
sudo nix-collect-garbage -d >/dev/null 2>&1
nix-collect-garbage -d >/dev/null 2>&1
echo update process finished