{ config, pkgs, nixvim, ... }:

with builtins;

let
  lib = pkgs.lib;

  old-unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/744d35f6298ce1638c6de5ec1d752840b3d1bdd4.tar.gz";
  }) {};
  godot_beta_16 = old-unstable.godot_4;
in {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    stateVersion = "23.05";
    packages = with pkgs; [
      wl-clipboard
      obsidian
      neofetch
      spotify
      blueman
      mpv
      yt-dlp
      ffmpeg
      zenith
      nurl
      wofi
      imagemagick
      gnome.simple-scan
      gnome.nautilus
      neovide
      libreoffice
      inkscape
      unzip
      zip
      imv
      killall
      gimp
      discord
      autotiling
      krita
      blender
      pamixer
      libnotify
      bitwarden
      grim
      dconf
      slurp
      gcc
    ] 
    ++
    ([
      godot_beta_16
    ]);
    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
    };  
    pointerCursor = {
      package = pkgs.catppuccin-cursors;
      name = "mochaLight";
      size = 16;
      gtk.enable = true;
    };
  };
  
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    config = {
      window = {
        titlebar = false;
      };
      keybindings =  
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "Shift+print" = "exec --no-startup-id slurp | grim -g - Pictures/Screenshots/$(date +'screenshot_%Y-%m-%d-%H%M%S.png') && notify-send Grim ''";
          "print" = "exec --no-startup-id grim  Pictures/Screenshots/$(date +'screenshot_%Y-%m-%d-%H%M%S.png') && notify-send Grim ''";
          "XF86AudioRaiseVolume" = "exec pamixer -i 5";
          "XF86AudioLowerVolume" = "exec pamixer -d 5";
          "XF86AudioMute" = "exec pamixer -t";
          "XF86AudioMicMute" = "exec pamixer -t";
        };
      terminal = "kitty --single-instance";
      menu = "killall wofi | wofi --show run";
      modifier = "Mod4";
      input = {
        "type:keyboard" = {
          xkb_layout = "it";
          xkb_numlock = "enabled";
        };
        "type:touchpad" = {
      	  dwt = "disabled";
	        tap = "enabled";
	        middle_emulation = "enabled";
          natural_scroll = "enabled";
      	};
      };
      startup = [
        { command = "mako"; }
        { command = "bitwarden"; }
        { command = "autotiling"; }
      ];
      bars = [{
        command = "waybar";
      }];
    };  
  };
  programs = {
    home-manager.enable = true;
    rofi = {
      enable = true;
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    nixvim = {
      extraPackages = with pkgs; [
        ripgrep
        fd
      ];
      extraPlugins = with pkgs.vimPlugins; [
        vim-nix
        neovim-ayu
        nvim-web-devicons
        mkdir-nvim
        lsp-colors-nvim
      ];
      enable = true;
      viAlias = true;
      vimAlias = true;
      options = {
        autoindent = true;              
        number = true;                  
        syntax = "true";                   
        mouse = "a";                 
        clipboard = "unnamedplus";   
        ttyfast = true;                 
        swapfile = false;              
        backup = false;               
        completeopt = "menu,menuone,noselect";
        writebackup = false;           
        undodir = "./.nixvim/undo";   
        undofile = true;		    
        undoreload = 10000;	    
        scrolloff = 10;            
        termguicolors = true;
      };
      colorscheme = "ayu-dark";
      maps = {
        normal."<M-Up>" = {
          silent = true;
          action = "<cmd>move-2<CR>";
        };
        insert."<M-Up>" = {
          silent = true;
          action = "<cmd>move-2<CR>";
        };
        normal."<M-Down>" = {
          silent = true;
          action = "<cmd>move+<CR>";
        };
        insert."<M-Down>" = {
          silent = true;
          action = "<cmd>move+<CR>";
        };
        normal."<C-Bslash>" = {
          silent = true;
          action = "<cmd>NvimTreeToggle<CR>";
        };
        insert."<C-Bslash>" = {
          silent = true;
          action = "<cmd>NvimTreeToggle<CR>";
        };
      };
      plugins = {
        comment-nvim = {
          enable = true;
          opleader.line = "<C-k>";
          toggler.line = "<C-k>";
        };
        indent-blankline = {
          enable = true;
          useTreesitterScope = true;
          useTreesitter = true;
        };
        nvim-colorizer = {
          enable = true;
        };
        trouble = {
          enable = true;
          icons = true;
          autoClose = true;
          autoOpen = true;
        };
        nvim-cmp = {
          enable = true;
          auto_enable_sources = true;
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = {
              modes = [ "i" "s" ];
              action = "
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end
              ";
            };
          };
        };
        treesitter-context = {
          enable = true;
        };
        treesitter-refactor = {
          enable = true;
        };
        treesitter = {
          enable = true;
          folding = true;
          indent = true;
          nixGrammars = true;
        };
        bufferline = {
          enable = true;
          alwaysShowBufferline = true;
        };
      	lualine = {
          enable = true;
          alwaysDivideMiddle = true;
        };
        nvim-tree = {
          enable = true;
          disableNetrw = true;
          git = {
            enable = true;
            ignore = false;
          };
          modified.enable = true;
          openOnSetup = true;
        };
        nix = {
          enable = true;
        };
        lsp = {
          enable = true;
          servers = {
            gdscript.enable = true;
            jsonls.enable = true;
            rnix-lsp.enable = true;
          };
        };
      };
    };
    waybar = { 
      enable = true;
      settings = {
        mainBar = {
          height = 16;
          layer = "top";
          position = "top";
          spacing = 2;
          modules-left = ["sway/workspaces"];
          modules-center = ["clock"];
          modules-right = ["tray" "pulseaudio" "network" "battery"];
          "sway/workspaces" = {
            "disable-scroll" = true;
              "all-outputs" = false;
              "format" = "{name}";
          };
          "tray" = {
            "icon-size" = 20;
            "spacing" = 10;
            "show_passive_items" = true;
          };
          "clock" = {
            "timezone" = "Europe/Rome";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "{:%Y-%m-%d}";
          };
          "battery" = {
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-charging" = "{capacity}% ";
            "format-plugged" = "{capacity}% ";
            "format-alt" = "{time} {icon}";
            "format-icons" = ["" "" "" "" ""];
          };
          "network" = {
            "format-wifi" = "{signalStrength}% ";
            "format-ethernet" = "";
            "tooltip-format" = "{ifname} via {gwaddr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "⚠";
            "format-alt" = "{essid}";
          };
          "pulseaudio" = {
            "format" = "{volume}% {icon}";
            "format-bluetooth" = "{volume}% {icon}";
            "format-bluetooth-muted" = "{icon} {format_source}";
            "format-muted" = "{format_source}";
            "format-source" = "";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" "" ""];
            };
          };
        };
      };
      style = "
* {
    transition: none;
    box-shadow: none;
    font-size: 13px;
    color: #f2f2f2;
}

#waybar {
    margin-top: 5px;
    margin-right: 5px;
    margin-left: 5px;
    background: #060608;
    /*border-radius: 10px;*/
    border: none;
}

#workspaces {
    margin: 0 3px;
    color: transparent;
}

#workspaces button {
    margin: 3px 0;
    padding: 0 3px;
}

#workspaces button.visible {
}

#workspaces button.focused {
    background: #32363d;
    border-radius: 10px;
}

#workspaces button.urgent * {
    color: #ff0055;
}


#mode, #battery, #bluetooth, #cpu, #disk, #memory, #temperature, #network, #pulseaudio, #idle_inhibitor, #backlight, #mpd, #clock, #temperature {
    margin: 4px 2px;
    padding: 0 8px;
    border-radius: 20px;
    min-width: 8px;
    background-color: #32363d;
}

#clock {
    margin: 4px 2px;
    padding: 0 10px;
  }

#tray {
    margin: 3px 2px;
    border-radius: 12px;
    background-color: #060608;
}
  
#tray * {
    padding: 0 6px;
    border-left: 1px solid #060608;
}
  
#tray *:first-child {
    border-left: none;
}

#mpd * {
    min-width: 10px;
    font-size: 11px;
    font-family: JetBrainsMono;
}
  
#custom-powermenu {
    margin: 4px 5px 4px 1px;
    padding: 0 6px;
    background-color: #722F37;
    border-radius: 10px;
    min-width: 15px;
}
  
#custom-launcher {
    margin: 4px 1px 4px 5px;
    padding: 0 6px;
    background-color: #ff0055;
    border-radius: 10px;
    min-width: 15px;
}

#battery.warning {
    color: #e5c07a
} 

#battery.critical {
    color: #ff0055
}

#temperature.critical {
    color: #e06b74;
}
      ";
    };
    git = {
      enable = true;
      userName = "Emaleth";
      userEmail = "Emaleth@protonmail.com";
      extraConfig = {
        core.editor = "vim";
        credential.helper = "cache";
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingKey = "~/.ssh/id_ed25519.pub";
      };
    };
    zathura = {
      enable = true;
    };
    kitty = {
      enable = true;
      font.size = 10;
      settings = {
        allow_remote_control = true;
      };
    };
    fish = {
      enable = true;
      loginShellInit = ''
        # autostart ssh-agent 
        eval "$(ssh-agent -c)"
        # autostart sway
        if test (id --user $USER) -ge 1000 && test (tty) = "/dev/tty1"
          exec sway
        end
      '';
      shellInit = ''
        set fish_greeting
      '';
    };
    mako = {
      enable = true;
      icons = true;
      actions = true;
      layer = "overlay";
      defaultTimeout = 5000;
      ignoreTimeout = true;
      anchor = "bottom-right";
    };
    brave.enable = true;
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        format = "$all$directory$character";
        scan_timeout = 10;
        character = {
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
        };
      };
    };
  };
  gtk = {
    enable = true;
  };
  services = {
    swayidle = {
      enable = true;
      timeouts = [ 
        { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -fF"; } 
      ];
    };
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableFishIntegration = true;
      extraConfig = "
        AddKeysToAgent yes;
      ";
      grabKeyboardAndMouse = true;
    };
  };
}

