# Host entrypoint. Generic system modules live in modules/nixos/; the
# Wayland compositor config lives in desktops/.
{...}: {
  imports = [
    ./hardware-configuration.nix
    ./modules/nixos
    ./desktops
  ];

  system.stateVersion = "26.05";
}
