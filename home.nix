{ config, pkgs, ... }:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;  
  sourceDir = /home/emaleth/Repositories/NixOS/dots;
in
{
  home = {
    file = {
      ".config/kitty/kitty.conf".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/kitty/kitty.conf;
      ".config/hypr/hyprland.conf".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/hyprland/hyprland.conf;
    };
    
    stateVersion = "22.11";
  };
}
