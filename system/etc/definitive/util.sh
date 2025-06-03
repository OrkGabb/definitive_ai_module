#!/system/bin/sh

log() {
    echo "[DEFINITIVE.AI][UTIL] $1" >> /dev/kmsg
}

get_temp() {
    for zone in /sys/class/thermal/thermal_zone*/temp; do
        [ -f "$zone" ] || continue
        temp=$(cat "$zone" 2>/dev/null)
        [ "$temp" -gt 0 ] && echo "$((temp / 1000))"
    done | sort -nr | head -n1
}

log "util.sh carregado com sucesso"
