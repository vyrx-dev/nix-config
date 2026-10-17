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
      stdenv.cc.cc.lib
      zlib
      openssl
    ];
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "vyrx"];
      auto-optimise-store = true;
    };
    # Generation cleanup is handled by nh clean (weekly, keeps 3 generations).
  };
}
