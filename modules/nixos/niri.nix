# Enables Niri as a second compositor alongside Sway. This is not a
# conflict: greetd's tuigreet (see the desktop/greetd module) already
# lists every available Wayland session and lets you pick one at login.
#
# `programs.niri` is nixpkgs' own module — no extra flake input needed,
# unlike some niri setups you'll see online that pull in niri-flake for a
# newer package version or Nix-native KDL config generation.
{lib, ...}: {
  programs.niri.enable = true;

  # Niri must route through the GNOME portal: it implements
  # org.gnome.Mutter.ScreenCast (required for gsr/OBS/Discord), while the wlr
  # portal has no niri backend. mkForce avoids the ~30s portal-selection freeze.
  xdg.portal.config.niri.default = lib.mkForce ["gnome"];
  xdg.portal.config.niri."org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
}
