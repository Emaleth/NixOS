#!/bin/sh
cd
cd Repositories/NixOS
sudo git add . && git commit -m "Auto Update" && git push
#sudo nix flake update
cd
nh os switch --update --impure --accept-flake-config
#sudo nixos-rebuild switch --flake /home/emaleth/Repositories/NixOS --impure
