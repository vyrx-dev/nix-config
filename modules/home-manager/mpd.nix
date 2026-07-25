# Runs MPD as a Home Manager-managed systemd --user service.
#
# This module generates ~/.config/mpd/mpd.conf — manual edits to that file
# will be overwritten. Socket activation (network.startWhenNeeded) means MPD
# doesn't start at login; it starts lazily when something (rmpc, mpc,
# mpd-mpris) connects to it, on 127.0.0.1:6600 and $XDG_RUNTIME_DIR/mpd/socket.
{config, ...}: {
  services.mpd = {
    enable = true;

    musicDirectory = "${config.home.homeDirectory}/Music/mpd";
    playlistDirectory = "${config.home.homeDirectory}/Music/Playlists";

    network = {
      listenAddress = "127.0.0.1";
      startWhenNeeded = true;
    };

    # No native option for these (yet) — extraConfig is the correct,
    # supported escape hatch for anything the module doesn't model.
    extraConfig = ''
      auto_update "yes"
      restore_paused "yes"
      max_output_buffer_size "16384"

      audio_output {
        type "pulse"
        name "pulse audio"
      }

      # FIFO output for cava-style visualizers
      audio_output {
        type   "fifo"
        name   "cava_fifo"
        path   "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };

  # MPRIS bridge, so media keys / playerctl / any MPRIS-aware widget can
  # see and control MPD. Points at the services.mpd instance above.
  services.mpd-mpris = {
    enable = true;
    mpd.useLocal = true;
  };
}
