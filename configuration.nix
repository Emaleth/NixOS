{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        extraEntriesBeforeNixOS = true;
        efiSupport = true;
        device = "nodev";
        extraEntries = ''
          menuentry "NixOS Recovery"
          chainloader /boot/loader/entries/nixos-generation-42.conf
        '';
      };
    };
  };
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    variables = {
      EDITOR = "hx";
      VISUAL = "kate";
    };
    systemPackages = with pkgs; [
      steam-run
      osslsigncode
      wine64
      yazi
      udiskie
      winetricks
      wofi
      mako
      waybar
      github-desktop
      nil
      godot_4-export-templates
      inkscape
      kdePackages.isoimagewriter
      kdePackages.ktorrent
      spotify
      gparted
      kdePackages.kdialog
      kdePackages.kate
      godot_4
#      hyprpolkitagent
      bitwarden
      libreoffice
      lightly-boehs
      hunspell
      kitty
      hunspellDicts.it_IT
      hunspellDicts.pl_PL
      discord
      krita
      google-chrome
      netflix
      blender
      helix
      gimp
      kdePackages.skanpage
    ];
  };
  
  networking.hostName = "nixos"; 

  fileSystems."/mnt/keychain" = {
    device = "/dev/disk/by-label/Keychain";
    fsType = "ext4";
    options = [
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
    ];
  };

  powerManagement = {
    resumeCommands = "
      ${pkgs.kmod}/bin/rmmod i2c_hid_acpi
      ${pkgs.kmod}/bin/modprobe i2c_hid_acpi
      ln -sfn /mnt/keychain/.ssh /home/emaleth/.ssh
    ";
    enable = true;
  };

  programs = {
    uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
    hyprlock.enable = true;
    bash.completion.enable = true;
    firefox.enable = true;
    steam.enable = true;
    hyprland.enable = true;
  # hyprland.withUWSM = true;
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
    dconf.enable = true;
    git.enable = true;
    starship.enable = true;
  };
  
  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
#      package = pkgs.hyprpolkitagent;
    };
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
    hypridle.enable = true;
    gvfs.enable = true;
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
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = true;
    sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin ];
    };
    graphics = {
      enable = true;
    };
  };
  system ={
    stateVersion = "24.11";
    activationScripts = {symlinks.text =
      "
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.gitconfig /home/emaleth/.gitconfig
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.config/hypr/hyprland.conf /home/emaleth/.config/hypr/hyprland.conf
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.config/kitty/kitty.conf /home/emaleth/.config/kitty/kitty.conf
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.config/helix/config.toml /home/emaleth/.config/helix/config.toml
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.config/yazi/yazi.toml /home/emaleth/.config/yazi/yazi.toml       
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.config/waybar/config /home/emaleth/.config/waybar/config 
        ln -sfn /mnt/keychain/.ssh /home/emaleth/.ssh
      ";
    };
  };
}
