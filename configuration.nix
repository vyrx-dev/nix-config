{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-7428c180-79d2-469a-83e0-39d1cb4366c5".device = "/dev/disk/by-uuid/7428c180-79d2-469a-83e0-39d1cb4366c5";
  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  hardware.bluetooth.enable = true;
 services.upower.enable = true;
 services.power-profiles-daemon.enable = true;


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {

    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # ================================================================================================
  # SPOTIFY AUDIO CUSTOMIZATION (Standard Look with Extensions & Marketplace)
  # ================================================================================================
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;

    # Explicitly left blank to preserve the raw, standard stock Spotify layout
    # Do not add theme or colorScheme options here

    # 1. FIXED: Marketplace is a custom app, so it must use the enabledCustomApps list!
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];

    # 2. Safe performance-optimized extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblockify    # Blocks audio and visual banner ads automatically
      hidePodcasts  # Strips out unwanted podcast bloat panels from your sidebar
      shuffle       # Fixes Spotify's broken native shuffle algorithms
    ];
  };


 # setting up keyd
  services.keyd = {
    enable = true;
    keyboards = {
     default = {
       ids = [ "*" ];
       settings = {
         main = {
           capslock = "overload(control, esc)";
           escape = "capslock";
	 };
       };
     };
   };
};


  # Enable the X11 windowing system.
  services.xserver.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."vyrx" = {
    isNormalUser = true;
    description = "vyrx";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

   fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # setting fish
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

# Enables a secure, universal background ssh-agent managed by systemd
  programs.ssh.startAgent = true;

  # # setting up tlp 
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     # Keep battery healthy capped at 60%
  #     START_CHARGE_THRESH_BAT0 = 55;
  #     STOP_CHARGE_THRESH_BAT0 = 60;
  #
  #     # Simple speed profile toggle (Max speed on wall, battery saver on go)
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #   };
  # };
  
  # Correct way to instruct sudo to preserve your editor variable in NixOS
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  environment.variables.SUDO_EDITOR = "nvim";
  security.sudo.extraConfig = ''
    Defaults env_keep += "SUDO_EDITOR"
  '';

 programs.git = {
    enable = true;
    config = {
      user.name = "vyrx";
      user.email = "theamit.969@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.thunar.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# ================================================================================================
  # SWAY & WAYLAND SYSTEM BASE
  # ================================================================================================

  programs.sway.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true; # CRITICAL: Do not remove or use mkForce false! Required for Sway screensharing and screenshots.
    
    config = {
      # Fallback defaults to prevent 30-second app initialization freeze timeouts
      common.default = [ "gtk" ];
      sway.default = lib.mkForce [ "wlr" "gtk" ]; 
    };
    
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome 
    ];
  };

  # Forces Chromium, Electron, and Brave to run natively via Wayland instead of lagging in Xwayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1"; # Critical: Stops your Nvidia GPU from lagging out your cursor!
    
    # Environment variables forcing cross-distro tools to stick to dark templates
    GTK_THEME = "Adwaita-dark";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  # ================================================================================================
  # SYSTEM PACKAGES ARRAY
  # ================================================================================================

  environment.systemPackages = with pkgs; [
    antigravity
    satty
    gpu-screen-recorder
    slurp
    grim
    jq
    bat
    btop
    brave  
    cmake
    cliphist
    deno
    eza  
    fd
    fastfetch
    fzf
    fuzzel  
    gnumake
    tmux
    lazygit
    go
    gopls 
    ghostty 
    github-cli 
    kanshi
    # keychain
    kitty 
    # mako  
    mpc
    mpd-mpris
    nodejs
    obs-studio
    opencode
    playerctl 
    ripgrep 
    rmpc
    spotify  
    starship
    # swaybg  
    vesktop
    vicinae
    vim
    # waybar 
    wget
    wl-clipboard
    xwayland-satellite  
    yazi  
    zed-editor 
    swaylock-effects
    zoxide
    heroic      # For your Epic, GOG, and custom repack installations
    mangohud    # Your FPS, temperature, and performance overlay tracker
    # --- Add these to fix your Neovim errors ---
    # luacheck          # Fixes luacheck error
    # stylua            # Fixes stylua error
    # python311Packages.flake8 # Fixes flake8 error
    # black             # Fixes black error
    # revive            # Fixes revive error for Go linting
    # tresitter
    bibata-cursors             # The official Material/Ice cursor framework package
    adwaita-icon-theme         # Essential fallback graphical system assets
    glib                       # Injects the 'gsettings' binary to force GTK4 changes
  ];

  # display manager
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.sway}/bin/sway"; 
        user = "vyrx";
      };
      default_session = {
        command = let
          sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        in "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-user --sessions ${sessions}";
        user = "greeter";
      };
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

# Enable KDE Connect and open required firewall ports
     programs.kdeconnect.enable = true;

    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
       # FIXED: Grants your user profile native compilation rights without sudo restrictions
       trusted-users = [ "root" "vyrx" ];
  };
    programs.noctalia = {
        enable = true;
    };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # ================================================================================================
  # GAMING & PERFORMANCE ENGINE
  # ================================================================================================

  # 1. Core Steam and Proton-GE Setup
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # Adds the experimental console-mode login option
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # 2. Automated Performance Priority (Replicates CachyOS background tuning)
  programs.gamemode.enable = true;

  # 3. Essential Graphic Drivers & 32-bit Compatibility for Steam
  hardware.graphics = {
    enable = true;
    enable32Bit = true; 
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # Proprietary drivers offer optimal performance for the RTX 2050
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Laptop Hybrid Routing: Wakes up the RTX 2050 when launching games
    prime = {
      amdgpuBusId = "PCI:4:0:0";  # Verified from your lspci output!
      nvidiaBusId = "PCI:1:0:0";  # Verified from your lspci output!
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # Keep true for now so you don't accidentally lock yourself out!
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "26.05"; # Did you read the comment?
}

