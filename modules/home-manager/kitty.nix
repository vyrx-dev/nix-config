{...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    settings = {
      window_padding_width = 0;
      background_opacity = "0.96";
      hide_window_decorations = "yes";
      scrollback_indicator_opacity = "0.0";

      cursor_trail = 10;
      cursor_trail_start_threshold = 0;
      cursor_trail_decay = "0.01 0.15";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      shell_integration = "no-cursor";

      enable_audio_bell = "no";
      confirm_os_window_close = 0;
      allow_remote_control = "yes";

      background = "#121212";
      foreground = "#c0c0c0";
      cursor = "#c0c0c0";
      cursor_text_color = "#000000";
      selection_foreground = "#0a0a0a";
      selection_background = "#c0c0c0";

      color0 = "#1a1a1a";
      color1 = "#c45555";
      color2 = "#9b8d7f";
      color3 = "#8c7f70";
      color4 = "#7a9aaa";
      color5 = "#999999";
      color6 = "#a7c7c7";
      color7 = "#c1c1c1";
      color8 = "#333333";
      color9 = "#d47070";
      color10 = "#9b8d7f";
      color11 = "#8c7f70";
      color12 = "#4a5f6a";
      color13 = "#999999";
      color14 = "#9cb7b7";
      color15 = "#c1c1c1";
    };
  };
}
