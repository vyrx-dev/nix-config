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

  # Cap battery charge at 60% to reduce wear
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="BAT0", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="60"
  '';

  services.blueman.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ GRAPHICS (NVIDIA PRIME OFFLOAD)                                       │
  # ╰───────────────────────────────────────────────────────────────────────╯

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam 32-bit + Wayland
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

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
  security.polkit.enable = true;

  # gsr-kms-server needs cap_sys_admin to read KMS/DRM framebuffers for screen
  # recording. security.wrappers persists the capability across rebuilds;
  # setcap on a store path would be lost on the next switch.
  security.wrappers.gsr-kms-server = {
    source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
    capabilities = "cap_sys_admin+ep";
    owner = "root";
    group = "root";
  };

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
    wlr.settings.screencast = {
      chooser_type = "simple";
      # slurp is not on the wlr portal's systemd PATH, so default chooser fails
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f '%o' -or";
    };

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

  # Nautilus only inline-extracts archives on double-click when it is the
  # default handler for the mimetype (see nautilus-mime-actions.c)
  xdg.mime.defaultApplications = {
    "application/x-7z-compressed" = "org.gnome.Nautilus.desktop";
    "application/x-7z-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-bzip" = "org.gnome.Nautilus.desktop";
    "application/x-bzip-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-compress" = "org.gnome.Nautilus.desktop";
    "application/x-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-cpio" = "org.gnome.Nautilus.desktop";
    "application/x-gzip" = "org.gnome.Nautilus.desktop";
    "application/x-lha" = "org.gnome.Nautilus.desktop";
    "application/x-lzip" = "org.gnome.Nautilus.desktop";
    "application/x-lzip-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-lzma" = "org.gnome.Nautilus.desktop";
    "application/x-lzma-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-tar" = "org.gnome.Nautilus.desktop";
    "application/x-tarz" = "org.gnome.Nautilus.desktop";
    "application/x-xar" = "org.gnome.Nautilus.desktop";
    "application/x-xz" = "org.gnome.Nautilus.desktop";
    "application/x-xz-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/zip" = "org.gnome.Nautilus.desktop";
    "application/gzip" = "org.gnome.Nautilus.desktop";
    "application/bzip2" = "org.gnome.Nautilus.desktop";
    "application/x-bzip2-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/vnd.rar" = "org.gnome.Nautilus.desktop";
    "application/zstd" = "org.gnome.Nautilus.desktop";
    "application/x-zstd-compressed-tar" = "org.gnome.Nautilus.desktop";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron/Chromium native Wayland
    WLR_NO_HARDWARE_CURSORS = "1"; # Fixes Nvidia cursor lag
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
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "vyrx";
      };
      default_session = {
        command = let
          sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        in "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-user-session --sessions ${sessions}";
        user = "greeter";
      };
    };
  };

  # Writable home for tuigreet to persist --remember / --remember-user state
  users.users.greeter = {
    home = "/var/lib/tuigreet";
    createHome = true;
    extraGroups = ["video"];
  };

  # tuigreet actually stores --remember state here, not in $HOME
  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet 0755 greeter greeter -"
  ];

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ USER ACCOUNT                                                          │
  # ╰───────────────────────────────────────────────────────────────────────╯

  users.users."vyrx" = {
    isNormalUser = true;
    description = "vyrx";
    extraGroups = ["networkmanager" "wheel" "i2c" "seat" "video" "render"];
  };

  users.defaultUserShell = pkgs.fish;

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ FONTS                                                                 │
  # ╰───────────────────────────────────────────────────────────────────────╯

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka-term
    nerd-fonts.caskaydia-cove
    nerd-fonts.hack
    nerd-fonts.fira-code
    inter
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
  programs.thunar.plugins = [pkgs.thunar-archive-plugin];
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

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;

  # No seatd on this system; tell libseat to use logind directly
  environment.variables.LIBSEAT_BACKEND = "logind";

  # ╭───────────────────────────────────────────────────────────────────────╮
  # │ SPOTIFY (Spicetify)                                                   │
  # ╰───────────────────────────────────────────────────────────────────────╯

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    enabledCustomApps = with spicePkgs.apps; [marketplace];
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
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
    glib # gsettings CLI for sway dconf theming
    bibata-cursors
    adwaita-icon-theme

    # ── Terminal & Shell ─────────────────────────────────────────────────
    ghostty
    tmux
    gum
    fzf
    eza
    feh
    bat
    fd
    fastfetch
    zoxide
    yazi
    jq
    wiremix
    wifitui

    # ── Editors & IDE ────────────────────────────────────────────────────
    vim
    zed-editor
    nixd
    alejandra
    grok-build

    # ── Development Tools ────────────────────────────────────────────────
    github-cli
    gh-dash
    lazygit
    cmake
    gnumake
    gcc
    go
    gopls
    nodejs
    deno
    python3
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
    ffmpeg.bin
    ffmpegthumbnailer
    hyprpicker

    # ── Internet & Communication ─────────────────────────────────────────
    brave
    inputs.zen-browser.packages."x86_64-linux".default
    vesktop
    geary
    localsend
    telegram-desktop
    opencode

    # ── Files & Productivity ─────────────────────────────────────────────
    evince
    nautilus
    file-roller
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
    antigravity-ide
    wlsunset
    scrcpy
    pavucontrol
    easyeffects
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
