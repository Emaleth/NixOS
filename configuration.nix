{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  boot = {
#    kernelPackages = pkgs.linuxPackages_5_15;
#    kernelParams = [""]; # fix touchpad not working after wake-up
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        extraEntriesBeforeNixOS = false;
        extraEntries = ''
          menuentry "NixOS Recovery"
          chainloader /boot/loader/entries/nixos-generation-28.conf
        '';
      };
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
      pkgs.kdePackages.isoimagewriter
      pkgs.spotify
      pkgs.gparted
      pkgs.libsForQt5.kate
      pkgs.godot_4
      pkgs.bitwarden
      pkgs.libreoffice-qt
      pkgs.hunspell
      pkgs.hunspellDicts.it_IT
      pkgs.hunspellDicts.pl_PL
      pkgs.discord
      pkgs.krita
      pkgs.google-chrome
      pkgs.netflix
      pkgs.blender
      pkgs.helix
      pkgs.hstr
      pkgs.gimp
      pkgs.libsForQt5.skanpage
    ];
  };
  
  networking.hostName = "nixos"; 

  powerManagement = {
    enable = true;
  };

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
      experimental-features = [
        "nix-command"
        "flakes" 
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = false;
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
    permittedInsecurePackages = [
      "electron-11.5.0"
      "electron-12.2.3"
      "electron-19.1.9"
    ];
  };
  
  services = {
    desktopManager.plasma6.enable = true;
    gvfs.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
        defaultSession = "plasma";
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
    acpid.enable = true;
  };
  
  hardware = {
    cpu.intel.updateMicrocode = true;
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
