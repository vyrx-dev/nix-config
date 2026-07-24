{...}: {
  programs.rmpc = {
    enable = true;
    config = builtins.readFile ./files/rmpc/config.ron;
  };

  xdg.configFile = {
    "rmpc/themes/theme.ron".source = ./files/rmpc/themes/theme.ron;
    "rmpc/fetch-lyrics" = {
      source = ./files/rmpc/fetch-lyrics;
      executable = true;
    };
  };
}
