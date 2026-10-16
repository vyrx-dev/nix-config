# Aggregator: imports every NixOS module in this directory.
{...}: {
  imports = [
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./hardware.nix
    ./graphics.nix
    ./audio.nix
    ./greeter.nix
    ./users.nix
    ./fonts.nix
    ./shell.nix
    ./editors.nix
    ./ssh.nix
    ./git.nix
    ./file-manager.nix
    ./keyboard.nix
    ./gaming.nix
    ./spicetify.nix
    ./virtualisation.nix
    ./secrets.nix
    ./packages.nix
    ./nix.nix
    ./codex-desktop.nix
  ];
}
