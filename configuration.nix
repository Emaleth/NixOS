{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nixpkgs.overlays = [ 
    inputs.niri.overlays.niri 
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
      EDITOR = "nvim";
      VISUAL = "nvim";
      XCURSOR_SIZE = "24";
    };

    systemPackages = with pkgs; [ 
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      discord
      kitty
      godot
      bitwarden-desktop
      libreoffice
      hunspell
      hunspellDicts.it_IT
      hunspellDicts.pl_PL
      krita
      ani-cli
      google-chrome
      nixd
      xwayland-satellite
      blender
      gimp
      kdePackages.breeze
      kdePackages.skanpage
      steam-run
      kdePackages.isoimagewriter
      kdePackages.ktorrent
      gparted
      kdePackages.kdialog
      tree-sitter
      ripgrep
    ];
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
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
  };
  programs = {
    noctalia-greeter = {
      enable = true;
      package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
      # Optional configuration
      greeter-args = "";
      settings.cursor = {
        theme = "breeze";
        size = 24;
        package = pkgs.kdePackages.breeze;
      };
    };
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    yazi = {
      enable = true;
      settings.yazi = {
        mgr = {
          show_hidden = true;
        };
      };
    };
    steam.enable = true;
    nvf = {
      enable = true;
      settings = {
        vim = {
          lazy.enable = false;
          viAlias = false;
          vimAlias = true;
          treesitter.enable = true;
          treesitter.context.enable = true;
          opts = {
            tabstop = 2;
            shiftwidth = 2;
            softtabstop = 2;
            expandtab = true;
            smarttab = true;
            clipboard = "unnamedplus";
            whichwrap = "<, >, [, ]";
          };
          clipboard = {
            enable = true;
            providers.wl-copy.enable = true;
            registers = "unnamedplus";
          };
          lsp = {
            enable = true;
            formatOnSave = true;
          };
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            markdown.enable = true;
            glsl.enable = true;
            fish.enable = true;
            nix = {
              enable = true;
              lsp.servers = [ "nixd" ];
            };
            css.enable = true;
            scss.enable = true;
            html.enable = true;
            json.enable = true;
            bash.enable = true;
            toml.enable = true;
            nim.enable = true;
          };
          statusline = {
            lualine = {
              enable = true;
              theme = "ayu_dark";
            };
          };
          autopairs.nvim-autopairs.enable = true;
          filetree.neo-tree.enable = true;
          telescope.enable = true;
          autocomplete = {
            nvim-cmp.enable = true;
            blink-cmp.enable = true;
          };
          snippets.luasnip.enable = true;
          tabline = {
            nvimBufferline.enable = true;
          };
          git = {
            enable = true;
            gitsigns.enable = true;
            neogit.enable = true;
          };
          minimap = {
            minimap-vim.enable = false;
            codewindow.enable = true; # lighter, faster, and uses lua for configuration
          };
          comments = {
            comment-nvim.enable = true;
          };
        };
      };
    };
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
  };

  time.timeZone = "Europe/Rome";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };
  };

  console.keyMap = "it";

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
      "electron-39.8.10"
    ];
  };

  services = {
    greetd.enable = true;
    xserver.enable = true;
    xserver.xkb.layout = "it";
    upower.enable = true;
    gvfs.enable = true;
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
    power-profiles-daemon.enable = true;
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
