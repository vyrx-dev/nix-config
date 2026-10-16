{pkgs, ...}: {
  # ntsync: low-latency Wine/Proton synchronization. Mainline since Linux 6.14.
  boot.kernelModules = ["ntsync"];

  programs.steam = {
    enable = true;
    # "Boot to Steam Big Picture" session; disabled so Steam doesn't show
    # up as an option in the greetd/tuigreet display manager. Steam itself
    # still works normally.
    gamescopeSession.enable = false;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;

  # No seatd on this system; tell libseat to use logind directly
  environment.variables.LIBSEAT_BACKEND = "logind";
}
