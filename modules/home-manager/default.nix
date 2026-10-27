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
    ./foot.nix
    ./fuzzel.nix
    ./starship.nix
    # ./ghostty.nix
    ./fish.nix
    ./direnv.nix
    ./dirs.nix
    ./tmux.nix
    ./kanshi.nix
    ./swaylock.nix
    ./cursor.nix
    ./theme.nix
    ./polkit.nix
    ./ai-usagebar.nix
    ./voxtype.nix
    ./toofan.nix
    ./gh-notify.nix
    ./herdr.nix
    ./nh.nix
    ./scripts.nix
  ];
}
