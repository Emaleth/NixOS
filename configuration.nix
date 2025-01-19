{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
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
      godot_4-export-templates
      github-desktop
      inkscape
      kdePackages.isoimagewriter
      kdePackages.ktorrent
      gparted
      kdePackages.kdialog
      godot_4
      bitwarden
      libreoffice
      hunspell
      hunspellDicts.it_IT
      hunspellDicts.pl_PL
      discord
      krita
      google-chrome
      blender
      helix
      gimp
      kdePackages.skanpage
    ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
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
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  programs = {
    fish.enable = true;
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
    firefox.enable = true;
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
    dconf.enable = true;
    git.enable = true;
    starship.enable = true;
  };
  
  fonts.packages = [ pkgs.nerd-fonts.symbols-only ];
  fonts.fontDir.enable = true;
  
  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
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
    gvfs.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    desktopManager = {
      plasma6.enable = true;
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
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.config/helix/config.toml /home/emaleth/.config/helix/config.toml
        ln -sfn /home/emaleth/Repositories/NixOS/dotfiles/.config/fish/config.fish /home/emaleth/.config/fish/config.fish 
        ln -sfn /mnt/keychain/.ssh /home/emaleth/.ssh
      ";
    };
  };
}
