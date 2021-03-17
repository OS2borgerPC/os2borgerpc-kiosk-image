#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    lts_upgrade_in_place_3.sh
#%
#% DESCRIPTION
#%    Step three of the upgrade from 16.04 to 20.04.
#%
#================================================================
#- IMPLEMENTATION
#-    version         lts_upgrade_in_place_step_3.sh 0.0.1
#-    author          Carsten Agger
#-    copyright       Copyright 2020, Magenta Aps
#-    license         BSD/MIT
#-    email           info@magenta.dk
#-
#================================================================
#  HISTORY
#     2021/01/13 : carstena : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================


set -ex

do-release-upgrade -f DistUpgradeViewNonInteractive >  /var/log/os2borgerpc_upgrade_2.log


apt-get update
apt-get install -y python3-pip

rm -r /usr/local/lib/python2.7
rm -r /usr/local/bin/*bibos*

pip3 install os2borgerpc-client
ln -s /var/lib/bibos /var/lib/os2borgerpc
ln -s /etc/bibos /etc/os2borgerpc

cp -r /home/chrome/.config/chromium/ /home/chrome/snap/chromium/common
chown -R chrome:chrome /home/chrome/snap/chromium/common
