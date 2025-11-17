#!/bin/bash

# Wait 9 seconds
sleep 9

# Launch Betterbird
uwsm-app -- betterbird & 

# Wait another 2 seconds to give the program time to start up
sleep 2

#  Switch to workspace 2
hyprctl dispatch workspace 2
