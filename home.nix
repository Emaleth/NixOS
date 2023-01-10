{ config, pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports = [
#    inputs.nixvim.homeManagerModules.nixvim
  ];
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    stateVersion = "22.11";
    sessionVariables = {
      XCURSOR_THEME = "numix";
    };
    packages = with pkgs; [
      wl-clipboard
      obsidian
      neofetch
      blueman
      mpv
      yt-dlp
      ffmpeg
      gnome.gnome-keyring
      zenith
      wofi
      imagemagick
      gnome.simple-scan
      libappindicator-gtk3
      spotify
      libreoffice
      godot
      inkscape
      gnome.nautilus
      unzip
      imv
#      nixvim
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
      (nerdfonts.override { fonts = ["Meslo"]; })
    ];
  };
  
  fonts.fontconfig.enable = true;
  
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
      terminal = "alacritty";
      menu = "killall wofi | wofi --show run";
      modifier = "Mod4";
      output = {
        "*" = {
          bg = "~/Pictures/Wallpapers/wallhaven-4ye12d.jpg fill";
        };
      };
      fonts = {
        names = [ "Meslo" ];
        style = "regular";
        size = 8.0;
      };
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
#    nixvim.enable = true;
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        format = "$all$directory$character";
        scan_timeout = 10;
        character = {
          success_symbol = "➜";
          error_symbol = "➜";
        };
      };
    };
    neovim = { 
      enable = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;
      extraPackages = [
        ripgrep
        fd
      ];
      plugins = with pkgs.vimPlugins; [ 
        vim-nix
        nvim-treesitter-context
        nvim-ts-autotag
        tokyonight-nvim
        nvim-ts-rainbow
        telescope-nvim # need to configure
        telescope-fzf-native-nvim # need to configure
        plenary-nvim # need to configure
        nvim-lspconfig # need to configure
        cmp-nvim-lsp # need to configure
        cmp-buffer # need to configure
        cmp-path # need to configure
        cmp-cmdline 
        mkdir-nvim
        aerial-nvim
        nvim-cmp 
        nvim-colorizer-lua
        luasnip
        bufferline-nvim
        twilight-nvim
        zen-mode-nvim
        pyright
        rnix-lsp
        rnvimr
        cmp_luasnip
        trouble-nvim
        indent-blankline-nvim-lua
        lualine-nvim
        nvim-treesitter-textobjects
        nvim-web-devicons
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-nix
            tree-sitter-css
            tree-sitter-html
            tree-sitter-toml
            tree-sitter-yaml
            tree-sitter-python
            tree-sitter-json
          ]
        ))
      ];
      extraConfig = ''
	      set nocompatible            
	      set showmatch               
	      set ignorecase              
	      set hlsearch                
	      set incsearch               
	      set tabstop=2               
	      set softtabstop=2           
	      set expandtab               
	      set shiftwidth=2            
	      set autoindent              
	      set number                  
	      set wildmode=longest,list   
	      filetype plugin indent on   
	      syntax on                   
	      set mouse=a                 
	      set clipboard=unnamedplus   
	      filetype plugin on          
	      set ttyfast                 
	      set noswapfile              
	      set nobackup                
	      set nowritebackup           
	      set undodir=~/.vim/backup   
	      set undofile		    
	      set undoreload=10000	    
	      set scrolloff=10            
	      let &fcs='eob: '            
        set completeopt=menu,menuone,noselect
        set termguicolors
        let g:nvim_tree_highlight_opened_files = 1

        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()

        nnoremap <C-Bslash> <cmd>RnvimrToggle<cr>
        nnoremap <A-Bslash> <cmd>AerialToggle<cr>
        nnoremap <S-Bslash> <cmd>TroubleToggle<cr>
        cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

        lua << EOF 
        vim.g.tokyonight_style = "night"
        vim.cmd[[colorscheme tokyonight]]
        
        require('indent_blankline').setup {
          show_current_context = true,
          show_current_context_start = true,
        }
        
        require('lualine').setup()
        
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true
          },
          indent = {
            enable = true
          },
          autotag = {
            enable = true
          },
          rainbow = {
            enable = true,
            extended_mode = true
          },
          textobjects = {
            select = {
              enable = true
            }
          }
        }
        
        require('telescope').setup{}

        local cmp = require'cmp'

        cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
          })
        })

        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({}, 
          {
            { name = 'buffer' },
          })
        })

        cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

        local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
        
        require('lspconfig')['pyright'].setup {
          on_attach = require("aerial").on_attach,
          capabilities = capabilities
        }
        require('lspconfig')['sumneko_lua'].setup {
          on_attach = require("aerial").on_attach,
          capabilities = capabilities
        }
        require('lspconfig')['rnix'].setup {
          on_attach = require("aerial").on_attach,
          capabilities = capabilities
      }

        require("twilight").setup{}

        require("bufferline").setup{}

        require("zen-mode").setup{}

        require('aerial').setup{}

        require("trouble").setup{}

        require("colorizer").setup{}
      '';
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
          "format" = "";
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
    alacritty = {
      enable = true;
      settings = {
        preview_images = true;
        preview_images_method = "Sixel";
        preview_files = true;
        mouse_enabled = true;
        font = {
          normal = {
        	  family = "monospace";
	          style = "regular";
	        };
	        bold = {
            family = "monospace";
            style = "regular";
          };
	        italic = {
	          family = "monospace";
	          style = "regular";
	        };
	        bold_italic = {
	          family = "monospace";
	          style = "regular";
          };
          size = 9.00;
        };
        colors = {
          # TokyoNight Alacritty Colors
          # Default colors
          primary = {
            background = "0x1a1b26";
            foreground = "0xc0caf5";
          };
          # Normal colors
          normal = {
            black = "0x15161E";
            red = "0xf7768e";
            green = "0x9ece6a";
            yellow = "0xe0af68";
            blue = "0x7aa2f7";
            magenta = "0xbb9af7";
            cyan = "0x7dcfff";
            white = "0xa9b1d6";
          };
          # Bright colors
          bright = {
            black = "0x414868";
            red = "0xf7768e";
            green = "0x9ece6a";
            yellow = "0xe0af68";
            blue = "0x7aa2f7";
            magenta = "0xbb9af7";
            cyan = "0x7dcfff";
            white = "0xc0caf5";
          };
          indexed_colors = [
            { index = 16; 
              color = "0xff9e64"; 
            }
            { 
              index = 17; 
              color = "0xdb4b4b";
            }
          ];
        };
      };
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
    fish = {
      enable = true;
      loginShellInit = ''
        # autostart ssh-agent 
        eval "$(ssh-agent -c)"
        # autostart sway
        if test (id --user $USER) -ge 1000 && test (tty) = "/dev/tty1"
	        exec sway
        end
        # sudo rmmod i2c_hid_acpi && sudo modprobe i2c_hid_acpi
      '';
      shellInit = ''
        # TokyoNight Color Palette
        set -l foreground c0caf5
        set -l selection 33467C
        set -l comment 565f89
        set -l red f7768e
        set -l orange ff9e64
        set -l yellow e0af68
        set -l green 9ece6a
        set -l purple 9d7cd8
        set -l cyan 7dcfff
        set -l pink bb9af7
    
        # Syntax Highlighting Colors
        set -g fish_color_normal $foreground
        set -g fish_color_command $cyan
        set -g fish_color_keyword $pink
        set -g fish_color_quote $yellow
        set -g fish_color_redirection $foreground
        set -g fish_color_end $orange
        set -g fish_color_error $red
        set -g fish_color_param $purple
        set -g fish_color_comment $comment
        set -g fish_color_selection --background=$selection
        set -g fish_color_search_match --background=$selection
        set -g fish_color_operator $green
        set -g fish_color_escape $pink
        set -g fish_color_autosuggestion $comment
    
        # Completion Pager Colors
        set -g fish_pager_color_progress $comment
        set -g fish_pager_color_prefix $cyan
        set -g fish_pager_color_completion $foreground
        set -g fish_pager_color_description $comment
      '';
    };
    swaylock.settings = {
      color = "#000000"; 
      font-size = 24; 
      indicator-idle-visible = false; 
      indicator-radius = 100; 
      line-color = "ffffff"; 
      show-failed-attempts = true; 
    };
  };
  gtk = {
    enable = true;
    font = {
      name = "Meslo";
      size = 9;
    }; 
    theme = {
      name = "Juno";
      package = pkgs.juno-theme;
    };
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
    gnome-keyring.enable = true;
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
