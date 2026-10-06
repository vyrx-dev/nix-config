#!/usr/bin/env bash

loops=0
while true; do
    read -r _ u1 n1 s1 i1 w1 r1 q1 _ < /proc/stat
    sleep 1
    read -r _ u2 n2 s2 i2 w2 r2 q2 _ < /proc/stat
    total=$(( (u2+n2+s2+i2+w2+r2+q2) - (u1+n1+s1+i1+w1+r1+q1) ))
    idle=$(( i2 - i1 ))
    CPU=$(awk "BEGIN {printf \"%d\", (1 - $idle/$total) * 100}")

    RAM=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%.1fG", (t-a)/1048576}' /proc/meminfo)

    TEMP="?"
    for zone in /sys/class/thermal/thermal_zone*; do
        [[ -f "$zone/type" ]] || continue
        t=$(< "$zone/type")
        if [[ "$t" == "x86_pkg_temp" || "$t" == "k10temp" ]]; then
            TEMP=$(($(< "$zone/temp") / 1000)); break
        fi
    done
    [[ "$TEMP" == "?" && -f /sys/class/thermal/thermal_zone0/temp ]] && \
        TEMP=$(($(< /sys/class/thermal/thermal_zone0/temp) / 1000))
    if (( TEMP >= 85 )); then
        TEMP_FMT="<span color='#ff5555'>${TEMP}°C</span>"
    else
        TEMP_FMT="${TEMP}°C"
    fi

    DISK=$(df -h / | awk 'NR==2 {print $4}')

    BAT=""
    if [[ -d /sys/class/power_supply/BAT0 ]]; then
        pct=$(< /sys/class/power_supply/BAT0/capacity)
        bat_status=$(< /sys/class/power_supply/BAT0/status)
        case "$bat_status" in
            Discharging)
                if (( pct <= 20 )); then
                    BAT=" | <span color='#ff5555'>BAT: ↓ ${pct}%</span>"
                elif (( pct <= 40 )); then
                    BAT=" | <span color='#ffff55'>BAT: ↓ ${pct}%</span>"
                else
                    BAT=" | BAT: ↓ ${pct}%"
                fi
                ;;
            Charging) BAT=" | BAT: ↑ ${pct}%" ;;
            *)        BAT=" | BAT: ${pct}%" ;;
        esac
    fi

    VOL=""
    vol_pct=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk '{print $5}' | head -1)
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
    if [[ "$muted" == "yes" ]]; then
        VOL=" | <span color='#ff5555'>VOL: mute</span>"
    elif [[ -n "$vol_pct" ]]; then
        VOL=" | VOL: ${vol_pct}"
    fi

    SSID=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
    if [[ -n "$SSID" ]]; then
        NET="<span color='#55ff55'>${SSID}</span>"
    else
        NET="<span color='#ff5555'>disconnected</span>"
    fi

    MEDIA=""
    play_status=$(playerctl status 2>/dev/null)
    if [[ "$play_status" == "Playing" || "$play_status" == "Paused" ]]; then
        artist=$(playerctl metadata artist 2>/dev/null)
        title=$(playerctl metadata title 2>/dev/null)
        if [[ -n "$title" && "$artist" != "<unknown>" && "$title" != "<unknown>" ]]; then
            [[ -n "$artist" ]] && track="${artist} - ${title}" || track="$title"
            [[ ${#track} -gt 40 ]] && track="${track:0:37}..."
            [[ "$play_status" == "Paused" ]] && prefix="⏸ " || prefix="⏵ "
            MEDIA=" | ${prefix}${track}"
        fi
    fi

    # Nix flake age (check every 60 seconds)
    if (( loops % 60 == 0 )); then
        last_epoch=$(jq -r '[.nodes[].locked.lastModified // empty] | max' /etc/nixos/flake.lock 2>/dev/null)
        if [[ -n "$last_epoch" && "$last_epoch" != "null" ]]; then
            nix_days=$(( ($(date +%s) - last_epoch) / 86400 ))
            [[ "$nix_days" == "0" ]] && nix_label="today" || nix_label="${nix_days}d"
            if (( nix_days > 7 )); then
                NIX="<span color='#ff5555'>❄ ${nix_label}</span>"
            else
                NIX="❄ ${nix_label}"
            fi
        else
            NIX="❄ ?"
        fi
    fi

    TIME=$(date +"%a %Y-%m-%d %H:%M")

    echo "CPU: ${CPU}% | ${TEMP_FMT} | RAM: ${RAM} | Disk: ${DISK}${BAT}${VOL} | ${NET} | ${NIX}${MEDIA} | ${TIME}"
    
    loops=$((loops + 1))
done
