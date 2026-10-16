{pkgs, ...}: {
  users.users."vyrx" = {
    isNormalUser = true;
    description = "vyrx";
    # i2c: ddcutil; seat/video/render: Wayland + GPU; libvirtd/docker: virtualisation
    extraGroups = ["networkmanager" "wheel" "i2c" "seat" "video" "render" "libvirtd" "docker"];
  };

  users.defaultUserShell = pkgs.fish;
}
