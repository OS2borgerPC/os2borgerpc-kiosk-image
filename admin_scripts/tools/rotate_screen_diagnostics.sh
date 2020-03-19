#!/bin/bash

# This script is for diagnostics purposes only - change and add commads
# as needed.
set -x

export XAUTHORITY=/home/chrome/.Xauthority

sudo -u chrome xrandr --listactivemonitors -display :0


active_monitors=($(sudo -u chrome xrandr --listactivemonitors -display :0 | grep -v Monitors | awk '{ print $4; }'))

active_monitors_array=($active_monitors)

echo $active_monitors_array

#sudo -u chrome xrandr --output HDMI1 --rotate right -display :0
#echo $?

sudo -u chrome xrandr --query -display :0

uptime


