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
      ".config/waybar/config".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/waybar/config;
      ".config/waybar/style.css".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/waybar/style.css;
      ".config/mako/config".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/mako/config;
      ".config/tofi/config".source = symlink /home/emaleth/Repositories/NixOS/dotfiles/tofi/config;
    };

    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 16;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "Vanilla-DMZ";
      };
    };
    stateVersion = "22.11";
  };
  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = "
      include /home/emaleth/Repositories/NixOS/dotfiles/sway/config
    ";
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };
  programs = {
    home-manager.enable = true;
    kitty = {
      enable = true;
      extraConfig = "
        ${builtins.readFile /home/emaleth/Repositories/NixOS/dotfiles/kitty/kitty.conf}
      ";
    };
    waybar.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
  };
  services = {
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      # settings = {
      #   program_options = {
      #     udisks_version = 2;
      #     tray = true;
      #   };
      #};
      tray = "auto";
    };
    gammastep = {
      enable = true;
      latitude = 43.8;
      longitude = 10.2;
      provider = "manual";
      settings = {
        general = {
          adjustment-method = "wayland";
        };
      };
    };
  };
}
