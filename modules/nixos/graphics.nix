{config, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam 32-bit + Wayland
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true; # required for the driver under Wayland
    open = false; # proprietary modules; safer than open for PRIME offload + suspend
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Persists VRAM across suspend/hibernate; fixes NVIDIA black-screen-on-resume.
    powerManagement.enable = true;

    prime = {
      # amdgpu = iGPU, nvidia = dGPU (bus IDs from lspci)
      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
