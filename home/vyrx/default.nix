# Home Manager configuration for user vyrx.
# This is imported as a NixOS module via home-manager.users.vyrx.
{...}: {
  imports = [
    ../../modules/home-manager
  ];

  home = {
    username = "vyrx";
    homeDirectory = "/home/vyrx";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
