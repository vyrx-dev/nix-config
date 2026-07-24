{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ BOOT & FILESYSTEM                                                     │
  # ╰───────────────────────────────────────────────────────────────────────╯

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-7428c180-79d2-469a-83e0-39d1cb4366c5".device = "/dev/disk/by-uuid/7428c180-79d2-469a-83e0-39d1cb4366c5";

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ NETWORKING                                                            │
  # ╰───────────────────────────────────────────────────────────────────────╯

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  # KDE Connect — open firewall ports for device pairing
  programs.kdeconnect.enable = true;
  networking.firewall.allowedTCPPorts = [53317];
  networking.firewall.allowedUDPPorts = [53317];

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ LOCALE & TIME                                                         │
  # ╰───────────────────────────────────────────────────────────────────────╯

  time.timeZone = "Asia/Kolkata";
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

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ HARDWARE                                                              │
  # ╰───────────────────────────────────────────────────────────────────────╯

  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true; # Required for ddcutil (monitor brightness control)

  # Battery charge limit — prevents degradation by capping at 60%
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="BAT0", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="60"
  '';

  services.blueman.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ GRAPHICS (NVIDIA PRIME OFFLOAD)                                       │
  # ╰───────────────────────────────────────────────────────────────────────╯

  # Essential for Steam 32-bit compatibility and Wayland native rendering
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # Proprietary drivers offer optimal performance for the RTX 2050
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Hybrid GPU routing: AMD iGPU for desktop, RTX 2050 offloaded for games
    prime = {
      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ AUDIO                                                                 │
  # ╰───────────────────────────────────────────────────────────────────────╯

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ DISPLAY SERVER & WAYLAND                                              │
  # ╰───────────────────────────────────────────────────────────────────────╯

  services.xserver.enable = false;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Ensures GTK apps find themes, icons, and schemas
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true; # Required for Sway screensharing and screenshots

    config = {
      # Prevents 30-second app init freeze when no default portal is set
      common.default = ["gtk"];
      sway.default = lib.mkForce ["wlr" "gtk"];
      # niri portal config lives in modules/nixos/niri.nix
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # Force Chromium/Electron/Brave to use native Wayland instead of XWayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1"; # Stops Nvidia GPU from lagging the cursor

    # Force GTK apps to use dark theme and Bibata cursor system-wide
    GTK_THEME = "Adwaita-dark";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ DISPLAY MANAGER (greetd + tuigreet)                                   │
  # ╰───────────────────────────────────────────────────────────────────────╯

  # Prevent accidental hard-shutdown on power button press
  services.logind.settings.Login.HandlePowerKey = "ignore";

  services.greetd = {
    enable = true;
    settings = {
      # Auto-login into Sway on first boot; tuigreet available for session switching
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

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ USER ACCOUNT                                                          │
  # ╰───────────────────────────────────────────────────────────────────────╯

  users.users."vyrx" = {
    isNormalUser = true;
    description = "vyrx";
    extraGroups = ["networkmanager" "wheel" "i2c"];
  };

  users.defaultUserShell = pkgs.fish;

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ FONTS                                                                 │
  # ╰───────────────────────────────────────────────────────────────────────╯

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ CORE PROGRAMS                                                         │
  # ╰───────────────────────────────────────────────────────────────────────╯

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  environment.variables.SUDO_EDITOR = "nvim";
  security.sudo.extraConfig = ''
    Defaults env_keep += "SUDO_EDITOR"
  '';

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
    '';
  };
  # Prevent gnome's gcr-ssh-agent (pulled in by xdg-desktop-portal-gnome)
  # from conflicting with programs.ssh.startAgent
  services.gnome.gcr-ssh-agent.enable = false;

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
  services.tumbler.enable = true;
  environment.pathsToLink = ["/share/thumbnailers"];

  # Remap CapsLock → Ctrl (hold) / Esc (tap); Esc → CapsLock
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings.main = {
        capslock = "overload(control, esc)";
        escape = "capslock";
      };
    };
  };

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ GAMING & PERFORMANCE                                                  │
  # ╰───────────────────────────────────────────────────────────────────────╯

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  programs.gamemode.enable = true;

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ SPOTIFY (Spicetify)                                                   │
  # ╰───────────────────────────────────────────────────────────────────────╯

  programs.spicetify = let
    # Fixed: use stdenv.hostPlatform.system (pkgs.system is deprecated)
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    enabledCustomApps = with spicePkgs.apps; [marketplace];
    enabledExtensions = with spicePkgs.extensions; [
      adblockify # Blocks audio and visual ads
      hidePodcasts # Strips podcast clutter from sidebar
      shuffle # Fixes Spotify's broken native shuffle
    ];
  };

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ SYSTEM PACKAGES                                                       │
  # ╰───────────────────────────────────────────────────────────────────────╯

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # ── Wayland / Desktop ───────────────────────────────────────────────
    swaybg
    swaylock-effects
    kanshi
    xwayland-satellite
    wl-clipboard
    cliphist
    grim
    slurp
    satty
    libnotify
    ddcutil
    glib # gsettings binary for GTK4 theming
    bibata-cursors
    adwaita-icon-theme

    # ── Terminal & Shell ─────────────────────────────────────────────────
    ghostty
    tmux
    gum
    fzf
    eza
    bat
    fd
    fastfetch
    zoxide
    yazi
    jq

    # ── Editors & IDE ────────────────────────────────────────────────────
    vim
    zed-editor
    nixd
    alejandra

    # ── Development Tools ────────────────────────────────────────────────
    github-cli
    lazygit
    cmake
    gnumake
    gcc
    go
    gopls
    nodejs
    deno
    python3Packages.flake8
    python3Packages.black
    lua54Packages.luacheck
    stylua
    lua-language-server
    revive
    gofumpt
    prettier
    eslint_d
    fixjson
    shellcheck
    shfmt
    hadolint

    # ── Media ────────────────────────────────────────────────────────────
    mpv
    yt-dlp
    obs-studio
    gpu-screen-recorder
    imagemagick
    ffmpegthumbnailer
    hyprpicker

    # ── Internet & Communication ─────────────────────────────────────────
    brave
    inputs.zen-browser.packages."x86_64-linux".default
    vesktop
    localsend
    opencode

    # ── Files & Productivity ─────────────────────────────────────────────
    evince
    foliate
    zathura
    obsidian
    anki
    transmission_4-gtk

    # ── Gaming ───────────────────────────────────────────────────────────
    heroic
    wine
    lutris
    mangohud

    # ── System Utilities ─────────────────────────────────────────────────
    btop
    mpc
    playerctl
    ripgrep
    wget
    vicinae
    spotify
    antigravity
  ];

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ NIX PACKAGE MANAGER                                                   │
  # ╰───────────────────────────────────────────────────────────────────────╯

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "vyrx"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  system.stateVersion = "26.05";
}
