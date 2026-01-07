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
    nautilus
    xwayland-satellite
    swaybg
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    gnome-keyring
  ];

  home.stateVersion = "25.11";

  programs = {
    home-manager.enable = true;
    discord.enable = true;
    helix.enable = true;
    nixvim.enable = true;
    noctalia-shell = {
      systemd.enable = true;
      enable = true;
      #package = null;
    };
    kitty = {
      enable = true;
    };
  };

  xdg.portal.extraPortals = [
    #xdg-desktop-portal-gtk
    #xdg-desktop-portal-gnome
    #gnome-keyring
  ];




  services = {
    swayidle.enable = true;
    mako.enable = true;
  };
}
