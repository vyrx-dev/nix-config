{...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-44c175f5-b2b4-4be8-b88f-11279ca0150f".device = "/dev/disk/by-uuid/44c175f5-b2b4-4be8-b88f-11279ca0150f";
  # xpad provides the controller driver used by the udev rule in hardware.nix.
  boot.kernelModules = ["xpad"];
}
