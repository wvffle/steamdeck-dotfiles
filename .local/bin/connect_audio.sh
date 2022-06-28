#!/bin/bash

AUDIO_SERVER_HOSTNAME=nyarch
STEAM_DECK_DEFAULT_SINK=alsa_output.pci-0000_04_00.5-platform-acp5x_mach.0.HiFi__hw_acp5x_1__sink

set_sink () {
	pactl set-default-sink $1
	for input in `pactl list sink-inputs | grep serial | cut -d \" -f 2`; do
		pactl move-sink-input $input $1
	done
}

connect_server () {
	PULSE_SERVER=tcp:$AUDIO_SERVER_HOSTNAME:4713 pactl info 2> /dev/null
	[[ $? != 0 ]] && sleep 10
	pactl load-module module-tunnel-sink server=tcp:$AUDIO_SERVER_HOSTNAME:4713 sink_name=$AUDIO_SERVER_HOSTNAME
	set_sink $AUDIO_SERVER_HOSTNAME
}

pactl unload-module module-tunnel-sink 2> /dev/null

[[ $1 = "up" ]] && {
	connect_server
	exit 0
}

[[ $1 = "down" ]] && {
	set_sink $STEAM_DECK_DEFAULT_SINK
	exit 0
}

# Check if we're connected to the ethernet or not
nmcli device status | grep ethernet | grep connected &> /dev/null
connected=$?

[[ $connected = 0 ]] && {
	connect_server
	exit 0
}

set_sink $STEAM_DECK_DEFAULT_SINK
