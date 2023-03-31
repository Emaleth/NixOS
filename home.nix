{ config, pkgs, ... }:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;  
  sourceDir = /home/emaleth/Repositories/NixOS/dots;
in
{
  home = {
    file = {
      ".config/kitty/kitty.conf".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/kitty/kitty.conf;
      ".config/hypr/hyprland.conf".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/hypr/hyprland.conf;
      ".config/helix/config.toml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/helix/config.toml;
      ".config/ranger/rc.conf".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/ranger/rc.conf;
      ".config/udiskie/config.yaml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/udiskie/config.yaml;
      ".config/fish/config.fish".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/fish/config.fish;
      # ".config/wofi/config".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/wofi/config;
      # ".config/wofi/style.css".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/wofi/style.css;
      ".config/starship.toml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/starship/starship.toml;
    };
    
    stateVersion = "22.11";
  };
}
