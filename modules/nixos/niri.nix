# Enables Niri as a second compositor alongside Sway. This is not a
# conflict: greetd's tuigreet (see the desktop/greetd module) already
# lists every available Wayland session and lets you pick one at login.
#
# `programs.niri` is nixpkgs' own module — no extra flake input needed,
# unlike some niri setups you'll see online that pull in niri-flake for a
# newer package version or Nix-native KDL config generation.
{lib, ...}: {
  programs.niri.enable = true;

  # Sway already gets an explicit xdg-desktop-portal default elsewhere in
  # this config, to avoid a ~30s portal-selection timeout on the first
  # screenshot/screen-share. Niri needs the identical override or it will
  # hit that same freeze the first time an app asks for a portal.
  xdg.portal.config.niri.default = lib.mkForce ["wlr" "gtk"];
}
