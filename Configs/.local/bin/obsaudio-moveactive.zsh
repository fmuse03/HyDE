#!/bin/zsh
active_pid="$(hyprctl activewindow -j | jq '.pid')"
sink_name='obsaudio'
sink_monitor="$sink_name"'.monitor'

for sink_input in ${(s:Sink Input #:)"$(pactl list sink-inputs)"}; do
	sink_id="$(echo "$sink_input" | sed -n '1p')"
	sink_pid="$(echo "$sink_input" | rg -P --only-matching '(?<=application.process.id = ").+(?="$)')"

	if [[ "$active_pid" == "$sink_pid" ]]; then
	  pactl move-sink-input "$sink_id" "$sink_name"
		echo "$active_pid"' (#'"$sink_id"') -> '"$sink_monitor"
	  break
	fi
done
