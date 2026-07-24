# Raw config deployed via xdg.configFile because the effect-scale key appears
# twice (scale-down → blur → scale-up trick) which an attrset cannot express.
# programs.swaylock.enable installs the package; settings = {} suppresses
# the auto-generated config so our xdg.configFile entry wins.
{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {};
  };

  xdg.configFile."swaylock/config".text = ''
    screenshots
    clock
    indicator
    indicator-radius=100
    indicator-thickness=10

    effect-scale=0.5
    effect-blur=7x5
    effect-scale=2
    effect-vignette=0.5:0.5

    ring-color=3e4451
    key-hl-color=5c6370
    inside-color=0f0f17cc
    text-color=abb2bf
    line-color=00000000
    separator-color=00000000

    ring-ver-color=5c6370
    inside-ver-color=0f0f17cc
    ring-wrong-color=e06c75
    text-wrong-color=e06c75

    ignore-empty-password
    show-failed-attempts
    font=Inter
    datestr=%a, %B %e
    timestr=%I:%M %p
  '';
}
