#!/bin/bash

# Monitornamen festlegen
HDMI="HDMI-A-0"
DP="DisplayPort-1"

# Funktion, um die maximale Bildwiederholrate für einen Monitor zu ermitteln
get_max_refresh_rate() {
    local monitor=$1
    # Suche nach der höchsten Bildwiederholrate in der xrandr-Ausgabe
    max_rate=$(xrandr | grep -A1 "^$monitor connected" | grep -oP '\d+\.\d+(?=\s*\+|\s*\*)' | sort -nr | head -n1)
    echo "$max_rate"
}

# Funktion, um den Monitor mit der gewünschten Bildwiederholrate zu konfigurieren
set_refresh_rate() {
    local monitor=$1
    local rate=$2
    local current_rate=$(get_max_refresh_rate "$monitor")

    if [[ "$current_rate" == "$rate" ]]; then
        echo "$monitor wird auf $rate Hz gesetzt (maximal verfügbar)"
        xrandr --output "$monitor" --rate "$rate"
    else
        echo "$monitor wird auf maximale Bildwiederholrate $current_rate Hz gesetzt"
        xrandr --output "$monitor" --rate "$current_rate"
    fi
}

# Aktuellen Primärmonitor ermitteln
current=$(xrandr | grep " connected primary" | awk '{print $1}')

# Wenn der aktuelle Primärmonitor DisplayPort-1 ist, wechsel zu HDMI-A-0 und setze die Bildwiederholrate
if [ "$current" = "$DP" ]; then
    echo "Wechsle zu HDMI-A-0 (max. 30 Hz)"
    set_refresh_rate "$HDMI" "30.00"  # Setze HDMI auf 30 Hz
    xrandr --output "$DP" --off --output "$HDMI" --auto --primary
else
    echo "Wechsle zu DisplayPort-1 (max. 164.92 Hz)"
    set_refresh_rate "$DP" "164.92"  # Setze DisplayPort auf 164.92 Hz
    xrandr --output "$HDMI" --off --output "$DP" --auto --primary
fi
