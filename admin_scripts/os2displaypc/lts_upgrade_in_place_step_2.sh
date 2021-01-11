#!/bin/bash


do-release-upgrade -f DistUpgradeViewNonInteractive > /dev/null

rm -r /usr/local/lib/python2.7
rm -r /usr/local/bin/*bibos*

apt install python3-pip
pip3 install os2borgerpc-client
