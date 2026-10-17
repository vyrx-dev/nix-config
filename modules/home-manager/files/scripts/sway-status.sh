#!/usr/bin/env bash

while true; do
    # Time
    TIME=$(date +"%Y-%m-%d %H:%M:%S")

    # CPU Load
    LOAD=$(cat /proc/loadavg | awk '{print $1}')
    
    # CPU Usage (approximate IDLE)
    # A simple way to get idle is using top or vmstat, but for a fast loop, reading /proc/stat is better.
    # We will just do a fast read using top for simplicity if needed, but top is slow.
    IDLE=$(top -b -n 1 | grep "%Cpu(s)" | awk '{print $8}')
    if [ -z "$IDLE" ]; then IDLE="0.0"; fi
    
    # Disk Usage
    DISK=$(df -h / | awk 'NR==2 {print $4}')
    
    # Temp
    # Will need to find the right thermal zone, usually /sys/class/thermal/thermal_zone0/temp
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        TEMP=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
    else
        TEMP="N/A"
    fi
    
    # Network IP
    IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
    if [ -z "$IP" ]; then IP="down"; fi

    echo "Useless Protocol: ipv6_here | Tea: ${TEMP} °C | Penger Folder: ${DISK} | E: Leaked IP: ${IP} | Fairy Dust: ${IDLE}% IDLE | Hot Loads: ${LOAD} | ${TIME}"
    
    sleep 1
done
