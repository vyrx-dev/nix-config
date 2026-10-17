# Scrobbles what MPD plays to Last.fm. home-manager automatically starts
# this after mpd.service since it detects mpd.nix's local MPD.
#
# The Last.fm password is provided by sops-nix (mpdscribble_lastfm_password
# in modules/nixos/secrets.nix). Never put a real password in Nix-managed
# files because the store is world-readable.
{config, ...}: {
  services.mpdscribble = {
    enable = true;

    endpoints."last.fm" = {
      username = "Amit-69";
      passwordFile = "${config.home.homeDirectory}/.config/mpdscribble/lastfm-password";
    };
  };
}
