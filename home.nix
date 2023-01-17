{ config, pkgs, nixvim, ... }:

with import <nixpkgs> {};
with builtins;
with lib;

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    stateVersion = "22.11";
    packages = with pkgs; [
      wl-clipboard
      obsidian
      neofetch
      blueman
      mpv
      yt-dlp
      ffmpeg
      zenith
      wofi
      imagemagick
      gnome.simple-scan
      libappindicator-gtk3
      spotify
      libreoffice
      godot
      inkscape
      unzip
      imv
      killall
      ranger
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
      ];
      maps = {
        normal."<C-Bslash>" = {
          silent = true;
          action = "<cmd>RnvimrToggle<CR>";
        };
      };
#      extraConfigLua = "
#        let g:rnvimr_enable_ex = 1
#        let g:rnvimr_enable_picker = 1
#        let g:rnvimr_edit_cmd = 'drop'
#        let g:rnvimr_enable_bw = 1
#        highlight link RnvimrNormal CursorLine
#      ";
      enable = true;
      viAlias = true;
      vimAlias = true;
      wrapRc = true;
      options = {
        nocompatible = true;            
        showmatch = true;               
        ignorecase = true;              
    	hlsearch = true;                
  	incsearch = true;               
	tabstop = 2;               
	softtabstop = 2;           
	expandtab = true;               
  	shiftwidth = 2;            
	autoindent = true;              
	number = true;                  
        wildmode = "longest, list";   
        #filetype plugin indent = on;   
	syntax = true;                   
	mouse = "a";                 
	clipboard = "unnamedplus";   
        #filetype plugin = on;          
	ttyfast = true;                 
	swapfile = false;              
	backup = false;               
  	writebackup = false;           
	undodir = ~/.vim/backup;   
	undofile = true;		    
	undoreload = 10000;	    
  	scrolloff = 10;            
        #&fcs = 'eob: ';            
        completeopt = "menu, menuone, noselect";
        termguicolors = true;
        foldmethod = "expr";
        foldexpr = "nvim_treesitter#foldexpr()";
      };
      plugins = {
        cmp-nvim-lsp.enable = true;
        cmp-nvim-lua.enable = true;
        cmp-treesitter.enable = true;
        cmp-snippy.enable = true;
	lsp = {
	  enable = true;
	  servers = {
	    cssls.enable = true;
	    gdscript.enable = true;
	    html.enable = true;
	    jsonls.enable = true;
	    rnix-lsp.enable = true;
	  };
	};
        telescope.enable = true;
        nix.enable = true;
        nvim-cmp.enable = true;
        treesitter-context.enable = true;
        treesitter = {
          enable = true;
          nixGrammars = true;
          indent = true;
          folding = true;
        };
        bufferline = {
          enable = true;
          alwaysShowBufferline = true;
        };
      	lualine = {
          enable = true;
          alwaysDivideMiddle = true;
        };
      };
    };
    waybar = { 
      enable = true;
      settings = {
        mainBar = {
          height = 16;
          layer = "top";
          position = "bottom";
          spacing = 2;
          margin-top = 2;
          margin-bottom = 2;
          modules-center = ["custom/launcher" "sway/workspaces" "tray" "custom/media" "pulseaudio" "network" "battery" "clock" "custom/power"];
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
            "on-click" = "pavucontrol";
          };
          "custom/launcher" = {
          "format" = "";
          "on-click" = "killall wofi | wofi --show run";
          };
          "custom/power" = {
            "format" = "" ;
          };	
        };
      };
      style = 
        "
        * {
          border: none;
          border-radius: 0px;
          font-family: Meslo;
          font-size: 12px;
          min-height: 0;
        }
        window#waybar {
          background-color: transparent;
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
        }
        window#waybar.hidden {
          opacity: 0.2;
        }
        #workspaces button {
          background: #1f1f1f;
          color: #ffffff;
          border-radius: 20px;
        }
        #workspaces button:hover {
          background: lightblue;
          color: black;
          border-bottom: 3px solid #ffffff;
        }
        #workspaces button.focused {
          background: #2BD2FF;
          color: black;
        }
        #workspaces button.focused:hover {
          background: lightblue;
          color: black;
          border-bottom: 3px solid #ffffff;
        }
        #workspaces button.urgent {
          background-color: #eb4d4b;
        }
        #clock,
        #battery,
        #network,
        #pulseaudio,
        #custom-launcher,
        #custom-power,
        #tray {
          padding: 0 10px;
          color: black;
          border-radius: 20px 0px 0px 20px;
        }
        #pulseaudio,
        #network,
        #battery {
          border-radius: 0px 0px 0px 0px;
        }
        #window,
        #workspaces {
          margin: 0px 4px;
        }
        .modules-left > widget:first-child > #workspaces {
          margin-left: 0px;
        }
        .modules-right > widget:last-child > #workspaces {
          margin-right: 0px;
        }
        #clock {
          background-color: #FA8BFF;
          background-image: linear-gradient(-45deg, #FA8BFF 0%, #2BD2FF 52%, #2BD2FF 90%);
          color: black;
          border-radius: 0px 20px 20px 0px;
          margin-right: 4px;
        }
        #battery {
          background-color: #ffffff;
          color: #000000;
        }
        #battery.charging, #battery.plugged {
          color: #ffffff;
          background-color: #26A65B;
        }
        @keyframes blink {
          to {
            background-color: #ffffff;
            color: #000000;
          }
        }
        #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        label:focus {
          background-color: #000000;
        }
        #network {
          background-color: #FA8BFF;
          background-image: linear-gradient(45deg, #2BD2FF 0%, #2BD2FF 52%, #2BD2FF 90%);
          color: black;
        }
        #network.disconnected {
          background-color: #FA8BFF;
          background-image: linear-gradient(45deg, #2BD2FF 0%, #2BD2FF 52%, #2BD2FF 90%);
          color: red;
        }
        #pulseaudio {
          background-color: #FA8BFF;
          background-image: linear-gradient(45deg, #2BD2FF 0%, #2BD2FF 52%, #2BD2FF 90%);
          color: black;
        }
        #pulseaudio.muted {
          background-color: #FA8BFF;
          background-image: linear-gradient(45deg, #2BD2FF 0%, #2BD2FF 52%, #2BD2FF 90%);
          color: red;
        }
        #custom-power{
          background-color: #FA8BFF;
          background-image: linear-gradient(45deg, #FA8BFF 0%, #2BD2FF 52%, #2BD2FF 90%);
          font-size: 16px;
          border-radius: 19px;
        }
        #custom-launcher{
          background-color: #FA8BFF;
          background-image: linear-gradient(-45deg, #FA8BFF 0%, #2BD2FF 52%, #2BD2FF 90%);
          font-size: 16px;
          border-radius: 19px;
        }
        #tray {
          background-color: #FA8BFF;
          background-image: linear-gradient(-45deg, #2BD2FF 0%, #2BD2FF 52%, #2BD2FF 90%);
          color: black;
        }
        #tray > .passive {
          -gtk-icon-effect: dim;
          background-color: #FA8BFF;
          background-image: linear-gradient(-45deg, #FA8BFF 0%, #2BD2FF 52%, #2BD2FF 90%);
          color: black;
        }
        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #FA8BFF;
          background-image: linear-gradient(-45deg, #FA8BFF 0%, #2BD2FF 52%, #2BD2FF 90%);
          color: black;
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
