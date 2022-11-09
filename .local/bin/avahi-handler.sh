#!/bin/bash

handle_state_change () {
	while read -r change; do
		state=`echo $change | cut -d ' ' -f 1`
		interface=`echo $change | cut -d ' ' -f 2`
		protocol=`echo $change | cut -d ' ' -f 3`
		host=`echo $change | cut -d ' ' -f 4 | cut -d '@' -f 2 | cut -d ':' -f 1`
		name=`echo $change | cut -d ':' -f 2`

		# NOTE: SERVICE ADDED
		[[ "$state" = "+" ]] && {
			# Sound server
			[[ "$host" = "paradise-lost" && "$name" = *PulseAudio\ Sound\ Sink* && "$protocol" = "IPv6" ]] && {
				pactl unload-module module-tunnel-sink
				pactl load-module module-tunnel-sink server=tcp:$host
			}
		}

		# NOTE: SERVICE REMOVED
		[[ "$state" = "-" ]] && {
			# Sound server
			[[ "$host" = "paradise-lost" && "$name" = *PulseAudio\ Sound\ Sink* && "$protocol" = "IPv6" ]] && {
				pactl unload-module module-tunnel-sink
				pactl load-module module-tunnel-sink server=tcp:$host
			}
		}
	done
}

avahi-browse --all --ignore-local | handle_state_change


