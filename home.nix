{ config, pkgs, ... }:

with builtins;

let
  lib = pkgs.lib;
in {
  imports = [
  ];
  home = {
    username = "emaleth";
    homeDirectory = "/home/emaleth";
    stateVersion = "23.05";
    packages = with pkgs; [
      wl-clipboard # clipboard manager
      obsidian # note taking and maps
      neofetch # fancy terminal system synopsis
      mpv # video player
      yt-dlp # youtube and similar downloader
      ffmpeg # audio / video stuff 
      nurl # get nixpkgs sha and rev for pinning
      wofi # menu 
      gnome.simple-scan # scanner program
      gnome.nautilus # file manager
      libreoffice # office but not office
      inkscape # vector graphics
      imv # terminal image viewer
      killall # kill them all, save yourself
      gimp # photoshop but not photoshop
      godot_4 # Game Engine, road to success and stuff
      discord # modern gamer chat
      autotiling # make sway usable
      krita # raster image editor
      blender # 3d model editor
      pamixer # audio controller
      libnotify # desktop notifications
      bitwarden # password and stuff
      grim # 
      slurp # 
      # LSP
      marksman
      nil
       ];
    sessionVariables = {
      EDITOR = "hx";
      SUDO_EDITOR = "hx";
      VISUAL = "hx";
    };  
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 16;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "Vanilla-DMZ";
      };
    };
  };
  
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    config = {
      gaps = {
        inner = 2;
      };
      floating = {
        titlebar = false;
        criteria = [
          { window_role = "pop-up"; }
          { window_role = "Pop-up"; }
          { window_role = "bubble"; }
          { window_role = "Bubble"; }
          { window_role = "dialog"; }
          { window_role = "Dialog"; }
          { window_role = "task_dialog"; }
          { window_role = "About"; }
          { window_type = "Dialog"; }
          { window_type = "dialog"; }
          { window_type = "menu"; }
          { class = "dialog"; }
          { class = "Dialog"; }
        ];
      };
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
    exa = {
      enable = true;
      enableAliases = true;
    };
    helix = {
      enable = true;
#      languages = [
#      ];
      settings = {
        editor = {
          bufferline = "always"; 
          color-modes = true;  
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "block";
            };
          indent-guides.render = true;
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
          margin-top = 2;
          margin-right = 2;
          margin-left = 2;
          modules-left = ["sway/workspaces"];
          modules-center = ["clock"];
          modules-right = ["tray" "pulseaudio" "network" "battery"];
          "sway/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = false;
            "format" = "{icon}";
            "persistent_workspaces" = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
              "6" = [];
              "7" = [];
              "8" = [];
              "9" = [];
            };
            "format-icons" = {
              "persistent" = "";
              "default" = "";
              "urgent" = "";
              "focused" = "";
            };
          };
          "tray" = {
            "icon-size" = 13;
            "spacing" = 4;
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
          font-size: 13px;
          color: @theme_text_color;
        }

        window#waybar {
          background: @theme_base_color;
          border-radius: 14px;
          border: none;
        }

        #battery, #bluetooth, #tray, #network, #pulseaudio, #clock, #user, #workspaces {
          background-color: #32363d;
          border-radius: 14px;
          margin: 2px;
          padding: 2px;
        }
        
        #workspaces button {
          min-height: 0px;
          min-width: 16px;
          margin: 0px;
          padding: 0px;       
        }

        #workspaces button.focused {
          color: #552373;
        }

        #workspaces button.urgent * {
          color: #ff0055;
        }

        #battery.warning {
          color: #e5c07a
        } 

        #battery.critical {
          color: #ff0055
        }
      ";
    };
    git = {
      enable = true;
      userName = "Emaleth";
      userEmail = "Emaleth@protonmail.com";
      extraConfig = {
        core.editor = "hx";
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
    mako = {
      enable = true;
      icons = true;
      actions = true;
      layer = "overlay";
      defaultTimeout = 5000;
      ignoreTimeout = true;
      anchor = "bottom-right";
    };
    swayidle = {
      enable = true;
      timeouts = [ 
        { timeout = 300; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; } 
        { timeout = 600; command = ''swaymsg "output * dpms off"''; resumeCommand = ''swaymsg "output * dpms on"''; }
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

