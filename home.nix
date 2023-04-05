{ config, pkgs, lib, inputs, hyprland, ... }:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;  
in
{
  imports = [
    hyprland.homeManagerModules.default
  ];
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    file = {
      ".config/kitty/kitty.conf".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/kitty/kitty.conf;
      ".config/helix/config.toml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/helix/config.toml;
      ".config/udiskie/config.yaml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/udiskie/config.yaml;
      ".config/fish/config.fish".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/fish/config.fish;
      ".config/starship.toml".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/starship/starship.toml;
      ".config/rofi/config.rasi".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/rofi/config.rasi;
      ".config/waybar/config".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/waybar/config;
      ".config/waybar/style.css".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/waybar/style.css;
      ".config/neofetch/config.conf".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/neofetch/config.conf;
     # ".config/mako/config".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/mako/config;
    };
    stateVersion = "22.11";
  };
  programs = {
    home-manager.enable = true;
    # helix = {
    #   enable = true;
    #   #settings = builtins.readfile /home/emaleth/repositories/nixos/dotfiles/helix/config.toml;
    # };
  };
  wayland.windowManager.hyprland = {
    enable = true;
      extraConfig = ''
        source = ~/Repositories/NixOS/dotfiles/hypr/hyprland.conf
      '';
  };
  services = {
    mako = {
      enable = true;
      extraConfig = builtins.readFile /home/emaleth/Repositories/NixOS/dotfiles/mako/config;
    };
  };
}
