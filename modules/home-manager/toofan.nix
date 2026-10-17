# Typing practice TUI, packaged by the project's own flake input.
{pkgs, inputs, ...}: {
  home.packages = [
    inputs.toofan.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
