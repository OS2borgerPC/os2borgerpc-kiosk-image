#!/bin/bash



do-release-upgrade -f DistUpgradeViewNonInteractive > /dev/null

rm -r /usr/local/lib/python2.7
rm -r /usr/local/bin/*bibos*

apt install -y python3-pip
ln -s /var/lib/bibos /var/lib/os2borgerpc
ln -s /etc/bibos /etc/os2borgerpc

pip3 install os2borgerpc-client
