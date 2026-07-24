# Aggregator: imports every NixOS module in this directory.
{...}: {
  imports = [
    ./niri.nix
  ];
}
