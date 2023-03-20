{ config, pkgs, lib, base16-schemes, modulesPath, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    # inputs.hyprland.nixosModules.default
    /etc/nixos/hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # hardware.bluetooth.enable = true;

  networking.hostName = "nixos"; # Define your hostname.

  # programs.hyprland.enable = true;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];
  };
  stylix = {
    image = /home/emaleth/Pictures/Wallpapers/wallhaven-8oev1j.jpg;
    base16Scheme = "${base16-schemes}/ayu-dark.yaml";
    polarity = "dark";
    fonts = { 
      serif = config.stylix.fonts.sansSerif;
      sansSerif = {
        package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
        name = "CascadiaCode";
      };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
        name = "CascadiaCode";
      };
      emoji = {
        package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
        name = "CascadiaCode";
      };
      sizes = {
        desktop = 10;
        applications = 10;
        terminal = 10;
        popups = 10;
      };
    };
  };
  security = {
    pam.services.swaylock = {
      text = "auth include login";
    };
    rtkit.enable = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
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
    getty.autologinUser = "emaleth";
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

  system.stateVersion = "22.11"; 

}
