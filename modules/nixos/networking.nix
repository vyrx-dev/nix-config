{...}: {
  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  # KDE Connect — open firewall ports for device pairing
  programs.kdeconnect.enable = true;
  networking.firewall.allowedTCPPorts = [53317];
  networking.firewall.allowedUDPPorts = [53317];
}
