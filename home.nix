{ config, pkgs, ... }:

{
  home.username = "emaleth";
  home.homeDirectory = "/home/emaleth";

  home.packages = with pkgs; [
    godot
    kitty
    godot-export-templates-bin
    bitwarden-desktop
    libreoffice
    hunspell
    hunspellDicts.it_IT
    hunspellDicts.pl_PL
    krita
    google-chrome
    nil
    blender
    gimp
    kdePackages.skanpage
    steam-run
    kdePackages.isoimagewriter
    kdePackages.ktorrent
    gparted
    kdePackages.kdialog
    kdePackages.kate
  ];

  home.stateVersion = "25.11";

  stylix = {
    enable = true;
    autoEnable = true;
    image = ./wallpapers/wallhaven-nme51y.jpg;
    polarity = "dark";
  };

  programs = {
    home-manager.enable = true;
    nixvim.enable = true;
    discord.enable = true;
    kitty = {
      enable = true;
    };
  };
  services = {
  };
}
