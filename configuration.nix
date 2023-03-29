{ config, pkgs, lib, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # hardware.bluetooth.enable = true;
  environment = {
    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
    systemPackages = [
      pkgs.steam-run
      pkgs.godot_4
      pkgs.neofetch
      pkgs.discord
      pkgs.krita
      pkgs.blender
      pkgs.bitwarden
      pkgs.kitty
      pkgs.chromium
      pkgs.helix
      pkgs.vscode
      pkgs.waybar
      pkgs.mako
      pkgs.wofi
      pkgs.hyprpaper

      # LSP
      pkgs.nil
      pkgs.marksman
    ];
    plasma5.excludePackages = [
      pkgs.libsForQt5.plasma-browser-integration
      pkgs.libsForQt5.konsole
      pkgs.libsForQt5.khelpcenter
      pkgs.libsForQt5.oxygen
      pkgs.libsForQt5.elisa
    ];
  };
  
  networking.hostName = "nixos"; # Define your hostname.
  
  documentation = {
    man.enable = false;
    doc.enable = false;
    dev.enable = false;
  };
  
  programs = {
    dconf.enable = true;
    fish = {
      enable = true;
      vendor = {
        functions.enable = true;
        config.enable = true;
        completions.enable = true;
      };
    };
    hyprland.enable = true;
    git.enable = true;
    starship.enable = true;
  };
  
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];
  };
  security = {
    rtkit.enable = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
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
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  
  services = {
    xserver = {
      layout = "it";
      xkbVariant = "";
      enable = true;
      displayManager = {
        defaultSession = "plasmawayland";
        sddm = {
          enable = true;
          autoNumlock = true;
        };
      };
      desktopManager = {
        plasma5.enable = true;
      };
    };
    pipewire = {
      enable = true;
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
      nssmdns = true;
    };
  };
  
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin ];
    };
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

    systemd.services.restart-trackpad= {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "wpa_supplicant.service" ];
    after = [ "wpa_supplicant.service" ];
    path = with pkgs; [ bash ];
    script = ''
      bash "sudo rmmod i2c_hid_acpi && sudo modprobe i2c_hid_acpi"
    '';
  };
  
  system.stateVersion = "22.11"; 

}
