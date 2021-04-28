#! /usr/bin/env sh

# Toggles kiosk mode for OS2DisplayPC Chromium
#
# Arguments:
# 1: "til" enables kiosk, "fra" disables it.
#
# Author: mfm@magenta.dk

USER='chrome'
TIL_FRA=$1

FILE=/home/$USER/.xinitrc

if [ "$TIL_FRA" = 'til' ]; then
  # Don't add --kiosk if it's already there
  if ! grep -q -- '--kiosk' $FILE; then
    sed -i 's/exec chromium-browser\(.*\)/exec chromium-browser --kiosk\1/' $FILE 
  fi
elif [ "$TIL_FRA" = 'fra' ]; then
  sed -i 's/--kiosk //g' $FILE
else
  printf  '%s\n' 'Ugyldig indstilling/parameter: Det skal være "til" eller "fra"'
  exit 1
fi
