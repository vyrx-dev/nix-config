{pkgs, ...}: {
  services.pulseaudio.enable = false; # replaced by PipeWire below
  security.rtkit.enable = true; # lets PipeWire grab realtime scheduling
  security.polkit.enable = true;

  # gsr-kms-server needs cap_sys_admin to read KMS/DRM framebuffers for screen
  # recording. security.wrappers persists the capability across rebuilds;
  # setcap on a store path would be lost on the next switch.
  security.wrappers.gsr-kms-server = {
    source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
    capabilities = "cap_sys_admin+ep";
    owner = "root";
    group = "root";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
