{ config, pkgs, ... }:

{
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    packages = with pkgs; [
      godot
      kitty
      urbanterror
      godot-export-templates-bin
      bitwarden-desktop
      libreoffice
      hunspell
      hunspellDicts.it_IT
      hunspellDicts.pl_PL
      krita
      ani-cli
      google-chrome
      nixd
      blender
      gimp
      kdePackages.skanpage
      steam-run
      kdePackages.isoimagewriter
      kdePackages.ktorrent
      xwayland-satellite
      gparted
      kdePackages.kdialog
      kdePackages.kate
    ];
  };
  home.stateVersion = "25.11";

  programs = {
    home-manager.enable = true;
    nixvim = {
      enable = true;
      plugins = {
        nil.sources.formatting.nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
      };
    };
    niri = {
      enable = true;
      settings = {
        spawn-at-startup = [
          {
            command = [
              "noctalia-shell"
            ];
          }
        ];
      };
    };
    noctalia-shell = {
      enable = true;
    };
    discord.enable = true;
    kitty = {
      enable = true;
    };
  };
  services = {
  };
}
