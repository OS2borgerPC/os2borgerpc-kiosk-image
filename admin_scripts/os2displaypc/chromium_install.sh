#!/bin/bash
# Minimal install of X and Chromium and connectivity.
apt-get install -y xinit xserver-xorg-core x11-xserver-utils --no-install-recommends --no-install-suggests
apt-get install -y chromium-browser > /dev/null

