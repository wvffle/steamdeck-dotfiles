#!/bin/bash

# Run the first time connection hooks
~/.local/bin/connect_audio.sh

# Listen for connections
~/.local/bin/network-manager-connection-action -c ~/.config/nm-hooks.conf
