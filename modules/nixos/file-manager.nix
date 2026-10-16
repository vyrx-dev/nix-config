{pkgs, ...}: {
  programs.thunar.enable = true;
  programs.thunar.plugins = [pkgs.thunar-archive-plugin];
  services.tumbler.enable = true;
  environment.pathsToLink = ["/share/thumbnailers"];
}
