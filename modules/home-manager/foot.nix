{...}: {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        dpi-aware = "no";
        pad = "6x6 center";
        initial-window-size-chars = "100x30";
      };

      bell = {
        system = "no";
      };

      scrollback = {
        lines = 5000;
      };

      mouse = {
        hide-when-typing = "yes";
      };

      "colors-dark" = {
        alpha = "0.96";
        background = "121212";
        foreground = "c0c0c0";
        cursor = "000000 c0c0c0";
        selection-foreground = "0a0a0a";
        selection-background = "c0c0c0";
        regular0 = "1a1a1a";
        regular1 = "c45555";
        regular2 = "9b8d7f";
        regular3 = "8c7f70";
        regular4 = "7a9aaa";
        regular5 = "999999";
        regular6 = "a7c7c7";
        regular7 = "c1c1c1";
        bright0 = "333333";
        bright1 = "d47070";
        bright2 = "9b8d7f";
        bright3 = "8c7f70";
        bright4 = "4a5f6a";
        bright5 = "999999";
        bright6 = "9cb7b7";
        bright7 = "c1c1c1";
      };

      csd = {
        preferred = "none";
      };

      tweak = {
        font-monospace-warn = "no";
      };
    };
  };
}
