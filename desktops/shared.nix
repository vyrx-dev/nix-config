{pkgs, ...}: {
  # Wayland-only; the nvidia videoDrivers set in graphics.nix still apply.
  services.xserver.enable = false;

  xdg.portal = {
    enable = true;

    # Prevents 30-second app init freeze when no default portal is set
    config.common.default = ["gtk"];

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # Double-clicking an archive extracts it in place only while Nautilus is the
  # mimetype's default handler (gnome-autoar), so every archive type points at
  # it. The list mirrors Nautilus' MimeType= entries; otherwise GIO can pick a
  # different claimant (zathura-cb also claims application/zip).
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
}
