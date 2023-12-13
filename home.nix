{ config, pkgs, lib, inputs, ... }:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;  
in
{
  imports = [
  ];
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    file = {
      ".config/helix/config.toml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/helix/config.toml;
      ".config/fish/config.fish".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/fish/config.fish;
      ".config/starship.toml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/starship/starship.toml;
      ".config/sway/config".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/sway/config;
      ".config/yambar/config.yml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/yambar/config.yml;
    };

    stateVersion = "23.11";
  };
  programs = {
    home-manager.enable = true;
  };
}
