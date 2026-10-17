# One file per compositor; greetd's tuigreet (modules/nixos/greeter.nix) lists
# every enabled session at login, so running more than one is not a conflict.
{...}: {
  imports = [
    ./shared.nix
    ./niri.nix
    ./sway.nix
  ];
}
