#!/bin/bash
# Minimal install of X and Chromium and connectivity.
apt-get install -y xinit xserver-xorg-core --no-install-recommends --no-install-suggests
apt-get install -y chromium-browser

