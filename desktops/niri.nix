# Niri as a second compositor alongside Sway. Not a conflict: greetd's
# tuigreet lists every available Wayland session at login.
#
# `programs.niri` is nixpkgs' own module — no niri-flake input needed. It also
# installs and configures the portals for us: xdg-desktop-portal-gnome routed
# through config.niri.default, gtk for FileChooser/Access/Notification, and
# gnome-keyring for Secret. So there is deliberately no xdg.portal override
# here — a mkForce would only fight upstream on the next nixpkgs bump.
{...}: {
  programs.niri.enable = true;
}
