# programs.waybar.systemd.enable defaults to false, so enable=true just
# installs + writes config. Waybar is launched via niri/sway spawn-at-startup.
{...}: {
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      reload_style_on_change = true;
      layer = "top";
      position = "bottom";
      exclusive = true;
      passthrough = false;
      height = 28;
      spacing = 0;

      modules-left = [
        "sway/workspaces"
        "niri/workspaces"
      ];
      modules-center = ["mpris"];
      modules-right = [
        # "group/tray-drawer"
        "custom/screenrecording-indicator"
        "custom/last-updated"
        "cpu"
        "temperature"
        "memory"
        "disk"
        "network"
        "pulseaudio"
        "battery"
        "clock"
        "tray"
      ];

      "custom/screenrecording-indicator" = {
        on-click = "~/Scripts/screenrecord";
        exec = "~/Scripts/indicator-record";
        interval = 2;
        signal = 8;
        return-type = "json";
      };

      "sway/workspaces" = {
        disable-scroll = false;
        all-outputs = false;
        format = "{name}";
        on-click = "activate";
      };

      "niri/workspaces" = {
        on-scroll-up = "niri msg action focus-window-or-workspace-up";
        on-scroll-down = "niri msg action focus-column-right-or-first";
      };

      mpris = {
        format = "{artist} • {title}";
        format-paused = "{artist} • {title}";
        format-stopped = "";
        max-length = 55;
        on-click = "playerctl play-pause";
        on-click-middle = "playerctl previous";
        on-click-right = "playerctl next";
      };

      "group/tray-drawer" = {
        orientation = "horizontal";
        drawer = {transition-duration = 200;};
        modules = ["custom/expand" "tray"];
      };

      "custom/expand" = {
        format = "❮";
        tooltip = false;
      };

      tray = {
        icon-size = 12;
        spacing = 4;
      };

      "custom/last-updated" = {
        exec = "~/.config/waybar/scripts/last-nix-update.sh";
        return-type = "json";
        interval = 1800;
        signal = 8;
        format = "  {}";
        tooltip = true;
      };

      cpu = {
        interval = 2;
        format = "cpu {usage}%";
        tooltip = true;
        states = {
          critical = 92;
        };
        on-click = "foot -e btop";
      };

      temperature = {
        interval = 5;
        thermal-zone = 0;
        format = "{temperatureC}°C";
        critical-threshold = 85;
        tooltip = false;
      };

      memory = {
        interval = 2;
        format = "mem {used:0.1f}gb";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        on-click = "foot -e btop";
      };

      disk = {
        interval = 30;
        path = "/";
        format = "disk {percentage_used}%";
        tooltip-format = "{used} / {total} ({percentage_free}% free)";
        on-click = "foot -e btop";
      };

      network = {
        format-wifi = "wifi {essid}";
        format-ethernet = "eth {ifname}";
        format-disconnected = "wifi --";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        on-click = "foot -e wifitui";
      };

      pulseaudio = {
        format = "vol {volume}%";
        on-click = "foot -e wiremix";
        on-click-right = "pamixer -t";
        tooltip-format = "vol {volume}%";
        scroll-step = 5;
        format-muted = "vol muted";
      };

      battery = {
        format = "bat {capacity}%";
        format-discharging = "bat {capacity}%";
        format-charging = "bat {capacity}%";
        format-plugged = "bat {capacity}%";
        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
        interval = 5;
        states = {
          warning = 20;
          critical = 10;
        };
        on-click = "~/Scripts/power-profile-menu";
      };

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%a, %d %b %Y}";
        tooltip = false;
      };
    };

    style = builtins.readFile ./files/waybar/style.css;
  };  home.file = {
    ".config/waybar/scripts/last-nix-update.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        # Days since the last `nix flake update`. Reads the mtime of flake.lock,
        # which is the moment the lock was last rewritten, so it answers "when
        # did I last update" rather than "how old is the newest input".
        lock=/etc/nixos/flake.lock
        ts=$(stat -c %Y "$lock" 2>/dev/null)
        [ -n "$ts" ] || exit 0

        now=$(date +%s)
        days=$(( (now - ts) / 86400 ))
        text="''${days}d"

        if [ "$days" -lt 7 ]; then
          class=ok
        elif [ "$days" -lt 14 ]; then
          class=warning
        else
          class=critical
        fi

        printf '{"text":"%s","class":"%s","tooltip":"last flake update: %s (%s ago)"}\n' \
          "$text" "$class" "$(date -d @"$ts" '+%a %d %b %Y %H:%M')" "$text"
      '';
    };
  };
}