{pkgs, ...}: {
  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true; # Required for ddcutil (monitor brightness control)

  # Cap battery charge at 60% to reduce wear
  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="BAT0", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="60"

    # Allow access to hidraw devices for WebHID (Orbit)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", TAG+="uaccess"
  '';

  services.blueman.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
