# Creates the user's home directories so a fresh machine is ready to use.
# The standard XDG set (Documents, Pictures, Music, Videos, Projects, ...) comes
# from xdg.userDirs; the extras below are directories this setup expects. Every
# entry is mkdir -p, so on an existing machine this is a no-op.
{config, lib, ...}: {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Not part of the XDG set: MPD's library/playlists, rmpc's lyrics cache, and
  # the scratch dirs used by the sessionX/tmux binds.
  home.activation.createExtraDirs = lib.hm.dag.entryAfter ["linkGeneration"] ''
    run mkdir -p $VERBOSE_ARG \
      "${config.home.homeDirectory}/Music/mpd" \
      "${config.home.homeDirectory}/Music/Playlists" \
      "${config.home.homeDirectory}/Music/lyrics" \
      "${config.home.homeDirectory}/testing"
  '';
}
