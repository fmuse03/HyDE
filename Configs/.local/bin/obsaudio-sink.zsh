#!/usr/bin/env zsh
sink_name='obsaudio'
sink_monitor="$sink_name"'.monitor'

if ! pactl list short sources | rg -F "$sink_monitor" >/dev/null; then
	default_sink=$(pactl get-default-sink)
	pactl load-module module-null-sink sink_name="$sink_name"
	pactl load-module module-loopback latency_msec=1 source="$sink_monitor" sink="$default_sink"
	pactl set-default-sink "$default_sink"
fi
