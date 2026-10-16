{pkgs, ...}: {
  # GNOME Boxes / libvirt
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # TPM emulation for Windows 11 / secure boot
    };
  };

  # Docker
  virtualisation.docker.enable = true;
}
