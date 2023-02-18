{ config, pkgs, nixvim, pkgs-unstable, ... }:

with builtins;

{
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    stateVersion = "22.11";
    packages = [
      # UNSTABLE
      pkgs-unstable.godot_4
      
      # STABLE
      pkgs.wl-clipboard
      pkgs.obsidian
      pkgs.neofetch
      pkgs.spotify
      pkgs.blueman
      pkgs.mpv
      pkgs.yt-dlp
      pkgs.ffmpeg
      pkgs.zenith
      pkgs.wofi
      pkgs.imagemagick
      pkgs.gnome.simple-scan
      pkgs.libreoffice
      pkgs.inkscape
      pkgs.unzip
      pkgs.zip
      pkgs.imv
      pkgs.killall
      pkgs.ranger
      pkgs.gimp
      pkgs.discord
      pkgs.autotiling
      pkgs.krita
      pkgs.blender
      pkgs.pamixer
      pkgs.libnotify
      pkgs.bitwarden
      pkgs.grim
      pkgs.dconf
      pkgs.slurp
      pkgs.gcc
    ];
    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
    };  
  };
  
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    config = {
      keybindings =  
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in pkgs.lib.mkOptionDefault {
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
        rnvimr
        mkdir-nvim
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
      colorschemes.gruvbox = {
        enable = true;
        contrastDark = "hard";
        #useTruecolor = true;
      };
      plugins = {
#        indent_blankline = {
#          enable = true;
#          useTreesitterScope = true;
#          useTreesitter = true;
#        };
#        nvim_colorizer = {
#          enable = true;
#        };
        trouble = {
          enable = true;
          icons = true;
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
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end
            '';
            };
          };
        };
#        treesitter-context = {
#          enable = true;
#        };
#        treesitter-refactor = {
#          enable = true;
#        };
#        treesitter = {
#          enable = false;#true;
#          folding = true;
#          indent = true;
#          nixGrammars = true;
#        };
        bufferline = {
          enable = true;
          alwaysShowBufferline = true;
        };
      	lualine = {
          enable = true;
          alwaysDivideMiddle = true;
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
        lsp-lines = {
          enable = true;
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
      userEmail = "";
      extraConfig = {
        core.editor = "vim";
	      credential.helper = "cache";
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
    iconTheme = {
      name = "luna-icons";
      package = pkgs.luna-icons;
    };
    cursorTheme = {
      name = "numix-cursor-theme";
      package = pkgs.numix-cursor-theme;
    }; 
  };
  services = {
    swayidle = {
      enable = true;
      timeouts = [ 
        { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -fF"; } 
      ];
    };
    blueman-applet = {
      enable = true;
    };
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "gtk2";
      enableFishIntegration = true;
      extraConfig = "
        AddKeysToAgent yes;
      ";
      grabKeyboardAndMouse = true;
    };
  };
}

