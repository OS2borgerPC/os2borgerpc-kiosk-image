#! /usr/bin/env sh

# Toggles kiosk and/or incognito mode for OS2DisplayPC Chromium
# Why incognito?: If kiosk is disabled the browser will begin to remember
# cookies after restart. If you don't want that you can enable incognito.
#
# Arguments:
# 1: 'false/falsk/no/nej' disables maximizing by default, anything else enables it.
# 2: 'false/falsk/no/nej' disables incognito by default, anything else enables it.
#
# Author: mfm@magenta.dk

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

USER='chrome'
ACTIVATE_KIOSK="$(lower "$1")"
ACTIVATE_INCOG="$(lower "$2")"

FILE=/home/$USER/.xinitrc

if [ "$ACTIVATE_KIOSK" != 'false' ] && [ "$ACTIVATE_KIOSK" != 'falsk' ] || \
   [ "$ACTIVATE_KIOSK" != 'no' ] && [ "$ACTIVATE_KIOSK" != 'nej' ]; then
  # Don't add --kiosk multiple times
  if ! grep -q -- '--kiosk' $FILE; then
    sed -i 's/exec chromium-browser\(.*\)/exec chromium-browser --kiosk\1/' $FILE 
  fi
else
  sed -i 's/--kiosk //g' $FILE
fi

if [ "$ACTIVATE_INCOG" != 'false' ] && [ "$ACTIVATE_INCOG" != 'falsk' ] || \
   [ "$ACTIVATE_INCOG" != 'no' ] && [ "$ACTIVATE_INCOG" != 'nej' ]; then
  # Don't add --incognito multiple times
  if ! grep -q -- '--incognito' $FILE; then
    sed -i 's/exec chromium-browser\(.*\)/exec chromium-browser --incognito\1/' $FILE 
  fi
else
  sed -i 's/--incognito //g' $FILE
fi
