{pkgs, inputs, ...}: {
  programs.voxtype = {
    enable = true;
    package = inputs.voxtype.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;
    model.name = "base.en";
    service.enable = true;
    settings = {
      hotkey = {
        enabled = false;
      };
      whisper = {
        language = "en";
      };
    };
  };
}
