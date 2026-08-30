{pkgs, inputs, ...}: {
  home.packages = [
    inputs.ai-usagebar.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."ai-usagebar/config.toml".text = ''
    # AI Usage Bar
    [antigravity]
    enabled = true
  '';
}
