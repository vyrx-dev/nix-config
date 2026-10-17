# programs.niri is nixpkgs' own module, so no niri-flake input is needed. It
# sets up the portals too: xdg-desktop-portal-gnome via config.niri.default,
# gtk for FileChooser/Access/Notification, and gnome-keyring for Secret. That
# is why there is no xdg.portal override here; a mkForce would only fight
# upstream on the next nixpkgs bump.
{...}: {
  programs.niri.enable = true;
}
