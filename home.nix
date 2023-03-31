{ config, pkgs, lib, inputs, hyprland, ... }:

let
#  imports = [
#    inputs.hyprland.homeManagerModules.default
#  ];
  symlink = config.lib.file.mkOutOfStoreSymlink;  
  sourceDir = /home/emaleth/Repositories/NixOS/dots;
in
{
  imports = [
    hyprland.homeManagerModules.default
  ];
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    file = {
      ".config/kitty/kitty.conf".source = symlink ~/Repositories/NixOS/dotfiles/kitty/kitty.conf;
      #".config/hypr/hyprland.conf".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/hypr/hyprland.conf;
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
  programs.home-manager.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
      extraConfig = ''
        source = ~/Repositories/NixOS/dotfiles/hypr/hyprland.conf
      '';
  };
}
