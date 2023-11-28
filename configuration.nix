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
      pkgs.android-studio
      pkgs.fuzzel
      pkgs.megacmd
      pkgs.trenchbroom
      pkgs.gnome.nautilus
      pkgs.gnome.gnome-keyring
      pkgs.gnome.sushi
      pkgs.autotiling
      pkgs.godot_4
      pkgs.polkit_gnome
      pkgs.libreoffice-qt
      pkgs.hunspell
      pkgs.hunspellDicts.it_IT
      pkgs.discord
      pkgs.mpv
      pkgs.krita
      pkgs.blender
      pkgs.imv
      pkgs.zathura
      pkgs.pixelorama
      pkgs.android-tools
      pkgs.bitwarden
      pkgs.chromium
      pkgs.helix
      pkgs.fnott
      pkgs.gimp
      pkgs.swaybg
      pkgs.grim
      pkgs.foot
      pkgs.slurp
      pkgs.libnotify
      pkgs.gnome.simple-scan
      pkgs.gcc
      pkgs.yambar
      pkgs.hugo

      # LSP
      pkgs.nil
      pkgs.marksman
      pkgs.taplo
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.yaml-language-server
    ];
  };
  
  networking.hostName = "nixos"; 
  
  programs = {
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
    seahorse.enable = true;
    gnome-disks.enable = true;
    adb.enable = true;
    light.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
    fish = {
      enable = true;
      vendor = {
        functions.enable = true;
        config.enable = true;
        completions.enable = true;
      };
    };
    git.enable = true;
    starship.enable = true;
  };
  
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];
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
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  
  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user-menu --cmd sway";
          user = "greeter";
        };
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
      nssmdns = true;
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

  system.stateVersion = "23.05"; 
}
