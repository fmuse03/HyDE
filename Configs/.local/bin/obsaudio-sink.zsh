#!/bin/zsh
sink_name="${1:-obsaudio}"
sink_monitor="$sink_name.monitor"

if ! pactl list short sources | rg -F "$sink_monitor" >/dev/null; then
	previous_default_sink=$(pactl get-default-sink)
	pactl load-module module-null-sink sink_name="$sink_name"
	pactl load-module module-loopback latency_msec=1 source="$sink_monitor" sink="$previous_default_sink"
	pactl set-default-sink "$previous_default_sink"
fi

for sink_input in ${(s:Sink Input #:)"$(pactl list sink-inputs)"}; do
	sink_id="$(echo "$sink_input" | sed -n '1p')"
	sink_should_move=0

	sink_binary="$(echo "$sink_input" | rg -P --only-matching '(?<=application.process.binary = ").+(?=")')"
	if [[ "$sink_binary" == 'wine64-preloader' ]]; then
		sink_should_move=1
	fi

	if [[ "$sink_should_move" == 1 ]]; then
		echo "$sink_id"
	  pactl move-sink-input "$sink_id" "$sink_name"
	fi
done
