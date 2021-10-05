#!/usr/bin/env sh

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

ACTIVATE="$(lower "$1")"

export DEBIAN_FRONTEND=noninteractive
FILE="/home/chrome/.xinitrc"

apt-get update --assume-yes

if [ "$ACTIVATE" != 'false' ] && [ "$ACTIVATE" != 'falsk' ] && \
   [ "$ACTIVATE" != 'no' ] && [ "$ACTIVATE" != 'nej' ]; then

  apt-get install --assume-yes unclutter

  if ! grep -q -- "unclutter" "$FILE"; then
    # 3 i means: Insert on line 3
    sed --in-place '3 i unclutter &' $FILE
  fi
else
  sed -i '/unclutter/d' $FILE
  apt-get --assume-yes remove unclutter
fi
