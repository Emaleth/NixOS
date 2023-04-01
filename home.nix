{ config, pkgs, lib, inputs, hyprland, ... }:

let
#  imports = [
#    inputs.hyprland.homeManagerModules.default
#  ];
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
    };
    stateVersion = "22.11";
  };
  #programs.home-manager.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
      extraConfig = ''
        source = ~/Repositories/NixOS/dotfiles/hypr/hyprland.conf
      '';
  };
}
