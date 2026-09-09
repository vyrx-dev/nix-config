{...}: {
  programs.topgrade = {
    enable = true;
    settings = {
      misc = { };
      pre_commands = {
        "Update NixOS Flake" = "sudo nix flake update --flake /etc/nixos";
      };
    };
  };
}