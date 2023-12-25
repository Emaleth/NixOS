{ config, pkgs, lib, inputs, ... }:

let

  catppuccin-kde-override = pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "green" ];
      winDecStyles = [ "modern" ];
  };
  catppuccin-gtk-override = pkgs.catppuccin-gtk.override {
    accents = [ "green" ];
    size = "compact";
    tweaks = [ "normal" ];
    variant = "mocha";
  };

in

{
  imports = [ 
    /etc/nixos/hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };
  environment = {
    variables = {
      EDITOR = "hx";
      VISUAL = "kate";
    };
    systemPackages = [
      pkgs.steam-run
      pkgs.android-studio
      pkgs.megacmd
      pkgs.catppuccin
      catppuccin-kde-override
      catppuccin-gtk-override
      pkgs.catppuccin-cursors.mochaDark
      pkgs.catppuccin-papirus-folders
      pkgs.papirus-folders
      pkgs.lightly-qt
      pkgs.libsForQt5.kate
      pkgs.itch
      pkgs.butler
      pkgs.godot_4
      pkgs.bitwarden
      pkgs.libreoffice-qt
      pkgs.hunspell
      pkgs.hunspellDicts.it_IT
      pkgs.discord
      pkgs.krita
      pkgs.chromium
      pkgs.blender
      pkgs.helix
      pkgs.gimp
    ];
  };
  
  networking.hostName = "nixos"; 
  
  programs = {
    bash.enableCompletion = true;
    firefox.enable = true;
    steam.enable = true;
    kdeconnect.enable = true;
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
    adb.enable = true;
    dconf.enable = true;
    git.enable = true;
    starship.enable = true;
  };
  
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      substituters = [
      ];
      trusted-public-keys = [
      ];
      experimental-features = [
        "nix-command"
        "flakes" 
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "03:15";
    };
  };
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Rome";

  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings = {
      LC_ADDRESS = "it_IT.utf8";
      LC_IDENTIFICATION = "it_IT.utf8";
      LC_MEASUREMENT = "it_IT.utf8";
      LC_MONETARY = "it_IT.utf8";
      LC_NAME = "it_IT.utf8";
      LC_NUMERIC = "it_IT.utf8";
      LC_PAPER = "it_IT.utf8";
      LC_TELEPHONE = "it_IT.utf8";
      LC_TIME = "it_IT.utf8";
    };
  };

  console.keyMap = "it2";

  users.users.emaleth = {
    isNormalUser = true;
    description = "Emaleth";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "lpadmin" 
      "video" 
      "scanner" 
      "adbusers"
      "plugdev"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  
  services = {
    gvfs.enable = true;
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager = {
        sddm.enable = true;
        defaultSession = "plasmawayland";
      };
    };
    pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };
  
  hardware = {
    bluetooth.enable = true;
    sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin ];
    };
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  system.stateVersion = "24.05"; 
}
