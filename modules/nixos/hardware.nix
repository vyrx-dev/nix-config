{pkgs, ...}: {
  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true; # Required for ddcutil (monitor brightness control)

  # Cap battery charge at 60% to reduce wear
  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="BAT0", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="60"

    # Fix for Cosmic Byte Blitz controller disconnecting from Steam
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05ac", ATTR{idProduct}=="033e", RUN+="${pkgs.bash}/bin/sh -c 'echo 05ac 033e > /sys/bus/usb/drivers/xpad/new_id'"
  '';

  services.blueman.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
