# Scrobbles what MPD plays to Last.fm. home-manager automatically starts
# this after mpd.service since it detects mpd.nix's local MPD.
#
# SECURITY: never put a real password directly in this file (or anywhere
# else Nix-managed) — the Nix store is world-readable. `passwordFile`
# points at a plain file kept OUTSIDE the store; create it by hand once:
#
#   mkdir -p ~/.config/mpdscribble
#   printf '%s' 'your-lastfm-password-or-md5' > ~/.config/mpdscribble/lastfm-password
#   chmod 600 ~/.config/mpdscribble/lastfm-password
#
# (The old mpdscribble.conf only had placeholder credentials, so there was
# nothing real to carry over here.)
#
# If you'd rather manage this secret declaratively too (agenix, sops-nix),
# that's a reasonable upgrade later — separate decision from this restructure.
{config, ...}: {
  services.mpdscribble = {
    enable = true;

    endpoints."last.fm" = {
      username = "theamit.969@gmail.com";
      passwordFile = "${config.home.homeDirectory}/.config/mpdscribble/lastfm-password";
    };
  };
}
