{
  config,
  pkgs,
  ...
}: {
  # Prevent accidental hard-shutdown on power button press
  services.logind.settings.Login.HandlePowerKey = "ignore";

  services.greetd = {
    enable = true;
    settings = {
      # Session greetd starts on boot; falls back to the tuigreet default_session.
      initial_session = {
        command = "niri-session";
        user = "vyrx";
      };
      default_session = {
        command = let
          sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        in "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-user-session --sessions ${sessions}";
        user = "greeter";
      };
    };
  };

  # Writable home for tuigreet to persist --remember / --remember-user state
  users.users.greeter = {
    home = "/var/lib/tuigreet";
    createHome = true;
    extraGroups = ["video"];
  };

  systemd.tmpfiles.rules = [
    # tuigreet stores --remember state here, not in $HOME
    "d /var/cache/tuigreet 0755 greeter greeter -"
  ];
}
