{pkgs, ...}: {
  # nix-ld: lets prebuilt (non-Nix) dynamic binaries run on NixOS.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      wayland
      libxkbcommon
      libGL
      fontconfig
      libx11
      libxcursor
      libxrandr
      libxi
    ];
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "vyrx"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
