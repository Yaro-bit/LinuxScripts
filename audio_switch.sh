#!/bin/bash

# Definiere die Gerätenamen
KOPFHOERER="alsa_output.usb-SteelSeries_Arctis_Nova_3-00.analog-stereo"
MONITOR="alsa_output.pci-0000_03_00.1.hdmi-stereo-extra2"

# Aktuelles Audio-Gerät abfragen
AUDIO_DEVICE=$(pactl info | grep "Default Sink" | cut -d ' ' -f3)

# Wenn das aktuelle Gerät der Monitor ist, wechsle zu den Kopfhörern, andernfalls zum Monitor
if [ "$AUDIO_DEVICE" == "$MONITOR" ]; then
    pactl set-default-sink $KOPFHOERER
else
    pactl set-default-sink $MONITOR
fi
