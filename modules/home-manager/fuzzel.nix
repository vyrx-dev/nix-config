{...}: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=10";
        width = 60;
        lines = 10;
        prompt = "> ";
        terminal = "kitty";
        match-mode = "fuzzy";
        horizontal-pad = 12;
        vertical-pad = 8;
        inner-pad = 6;
        layer = "overlay";
        exit-on-keyboard-focus-loss = "yes";
      };

      colors = {
        background = "0d0d0dff";
        text = "999999ff";
        match = "ccccccff";
        selection = "1a1a1aff";
        selection-text = "e0e0e0ff";
        selection-match = "ffffffc0";
        border = "1a1a1aff";
      };

      border = {
        width = 1;
        radius = 4;
      };

      key-bindings = {
        delete-line-forward = "none";
        prev = "Up Control+p Control+k";
        next = "Down Control+n Control+j";
        cancel = "Escape";
      };
    };
  };
}
