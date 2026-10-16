{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    tree-sitter
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
    noctalia

    # ── Terminal & Shell ─────────────────────────────────────────────────
    tmux
    gum
    fzf
    eza
    feh
    bat
    tree
    fd
    fastfetch
    zoxide
    yazi
    jq
    zip
    wiremix
    wifitui

    # ── Editors & IDE ────────────────────────────────────────────────────
    vim
    zed-editor
    nixd
    alejandra
    code-cursor

    # ── AI Agents & Assistants ───────────────────────────────────────────
    opencode
    t3code

    # ── Development Tools ────────────────────────────────────────────────
    github-cli
    usbutils
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
    lazydocker
    gnome-boxes

    # ── Rust ─────────────────────────────────────────────────────────────
    rustc
    cargo
    rustfmt
    rust-analyzer

    # ── Media ────────────────────────────────────────────────────────────
    mpv
    yt-dlp
    cliamp
    obs-studio
    gpu-screen-recorder
    imagemagick
    ffmpeg.bin
    ffmpegthumbnailer
    hyprpicker

    # ── Internet & Communication ─────────────────────────────────────────
    brave
    vesktop
    localsend
    telegram-desktop

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
    ludusavi

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
}
