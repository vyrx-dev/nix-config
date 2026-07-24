# Sway config is raw DSL — managed as a file rather than converted to
# HM structured options to preserve the exact config verbatim.
# programs.sway.enable = true in configuration.nix handles the system-level
# session/environment setup; this only manages the user config file.
{...}: {
  xdg.configFile."sway/config".source = ./files/sway/config;
}
