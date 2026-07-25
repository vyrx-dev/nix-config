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
        "group/tray-drawer"
        "custom/screenrecording-indicator"
        "cpu"
        "memory"
        "disk"
        "network"
        "pulseaudio"
        "battery"
        "clock"
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

      cpu = {
        interval = 2;
        format = "cpu {usage}%";
        tooltip = true;
        on-click = "ghostty -e btop";
      };

      memory = {
        interval = 2;
        format = "mem {used:0.1f}gb";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        on-click = "ghostty -e btop";
      };

      disk = {
        interval = 30;
        path = "/";
        format = "disk {percentage_used}%";
        tooltip-format = "{used} / {total} ({percentage_free}% free)";
        on-click = "ghostty -e btop";
      };

      network = {
        format-wifi = "wifi {essid}";
        format-ethernet = "eth {ifname}";
        format-disconnected = "wifi --";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        on-click = "ghostty -e wifitui";
      };

      pulseaudio = {
        format = "vol {volume}%";
        on-click = "ghostty -e wiremix";
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
      };

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%a, %d %b %Y}";
        tooltip = false;
      };
    };

    style = builtins.readFile ./files/waybar/style.css;
  };
}
