{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = null; # managed as a system package in environment.systemPackages
    systemd.enable = false;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-style = "Medium";
      font-size = 11;

      mouse-hide-while-typing = true;

      window-theme = "ghostty";
      window-padding-x = 10;
      window-padding-y = 0;
      confirm-close-surface = false;
      resize-overlay = "never";
      gtk-toolbar-style = "flat";
      background-opacity = 0.96;

      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";

      keybind = [
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:bottom"
        "ctrl+shift+k=goto_split:top"
        "ctrl+shift+l=goto_split:right"
        "super+shift+enter=new_split:auto"
        "super+alt+m=toggle_split_zoom"
        "super+shift+q=close_surface"
        "ctrl+shift+comma=reload_config"
      ];

      scrollback-limit = 100000;
      mouse-scroll-multiplier = 2;

      background = "#121212";
      foreground = "#c0c0c0";
      cursor-color = "#c0c0c0";
      selection-foreground = "#0a0a0a";
      selection-background = "#c0c0c0";

      palette = [
        "0=#1a1a1a"
        "1=#a85858"
        "2=#6a8a5a"
        "3=#c4a65a"
        "4=#6a7a8a"
        "5=#8a6a8a"
        "6=#6a8a8a"
        "7=#a0a0a0"
        "8=#3a3a3a"
        "9=#c06060"
        "10=#8aaa7a"
        "11=#d4b87c"
        "12=#7a8a9a"
        "13=#9a7a9a"
        "14=#7a9a9a"
        "15=#c0c0c0"
      ];
    };
  };
}
