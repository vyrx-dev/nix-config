{...}: {
  xdg.configFile."autostart/blueman.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Blueman Applet
    Exec=blueman-applet
    Hidden=true
  '';
}
