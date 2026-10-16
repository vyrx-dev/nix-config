{...}: {
  # Remap CapsLock → Ctrl (hold) / Esc (tap); Esc → CapsLock
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings.main = {
        capslock = "overload(control, esc)";
        escape = "capslock";
      };
    };
  };
}
