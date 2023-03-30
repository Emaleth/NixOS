{ config, pkgs, lib, inputs, ... }:

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
      pkgs.waybar
      pkgs.mako
      pkgs.wofi
      pkgs.hyprpaper
      pkgs.libsForQt5.dolphin
      pkgs.libsForQt5.polkit-kde-agent
      pkgs.gparted
      pkgs.grim
      pkgs.hyprpicker
      
      # LSP
      pkgs.nil
      pkgs.marksman
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.yaml-language-server
    ];
  };
  
  networking.hostName = "nixos"; 
  
  documentation = {
    man.enable = false;
    doc.enable = false;
    dev.enable = false;
  };
  
  programs = {
    light.enable = true;
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
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user-menu --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    xserver = {
      layout = "it";
      xkbVariant = "";
      enable = true;
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
