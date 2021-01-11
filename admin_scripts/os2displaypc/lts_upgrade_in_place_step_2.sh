#!/bin/bash


do-release-upgrade -f DistUpgradeViewNonInteractive > /dev/null

rm -r /usr/local/lib/python2.7
rm -r /usr_local/bin/*bibos*

apt install python3-pip
pip install os2borgerpc-client
