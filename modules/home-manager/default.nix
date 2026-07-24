# Aggregator: imports every Home Manager module in this directory.
{...}: {
  imports = [
    ./mpd.nix
    ./mpdscribble.nix
    ./rmpc.nix
    ./niri.nix
    ./sway.nix
    ./waybar.nix
    ./mako.nix
    ./kitty.nix
    ./fuzzel.nix
    ./starship.nix
    ./ghostty.nix
    ./fish.nix
    ./tmux.nix
    ./kanshi.nix
    ./swaylock.nix
  ];
}
