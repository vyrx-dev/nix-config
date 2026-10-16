# Aggregator for Wayland session config. Each compositor lives in its own
# file; greetd's tuigreet (modules/nixos/greeter.nix) lists every enabled
# session at login, so enabling two compositors here is not a conflict.
{...}: {
  imports = [
    ./shared.nix
    ./niri.nix
    ./sway.nix
  ];
}
