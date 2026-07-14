#!/bin/sh
cd
cd Repositories/NixOS
sudo git add . && git commit -m "Auto Update" && git push
echo "git repo updated"
sudo nix flake update
echo "flake updated"
cd
#nh os switch --update --impure --accept-flake-config
sudo nixos-rebuild switch --flake /home/emaleth/Repositories/NixOS --impure
echo "system updated"
