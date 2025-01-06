#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
  echo "Critical error. Halting registration: This program must be run as root"
  exit 1
fi

# install os2borgerpc-client
install_client.sh

# Register 
register_new_os2borgerpc_client.sh