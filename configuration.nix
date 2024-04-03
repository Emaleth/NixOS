{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  boot = {
#    kernelPackages = pkgs.linuxPackages_5_15;
#    kernelParams = [""];
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
        extraEntries = ''
          menuentry "NixOS Recovery"
          chainloader /boot/loader/entries/nixos-generation-34.conf
        '';
      };
    };
  };
  environment = {
    variables = {
      EDITOR = "hx";
      VISUAL = "kate";
    };
    systemPackages = with pkgs; [
      steam-run
      android-studio
      kdePackages.isoimagewriter
      spotify
      gparted
      kdePackages.kdialog
      kdePackages.kate
      godot_4
      bitwarden
      libreoffice
      lightly-boehs
      hunspell
      hunspellDicts.it_IT
      hunspellDicts.pl_PL
      discord
      krita
      google-chrome
      netflix
      blender
      helix
      hstr
      gimp
      kdePackages.skanpage
      zapzap
    ];
  };
  
  networking.hostName = "nixos"; 

  powerManagement = {
    resumeCommands = "
      ${pkgs.kmod}/bin/rmmod i2c_hid_acpi
      ${pkgs.kmod}/bin/modprobe i2c_hid_acpi
      ln -sfn /run/media/emaleth/Keychain/.ssh /home/emaleth/.ssh
    ";
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
    permittedInsecurePackages = [];
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
# test sa
  system ={
    stateVersion = "24.05";
    activationScripts = {symlinks.text =
      "
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.gitconfig /home/emaleth/.gitconfig
        ln -sfn /run/media/emaleth/Keychain/.ssh /home/emaleth/.ssh
      ";
    };
  };
}
