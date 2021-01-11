#!/bin/bash

# Patch jobmanager to avoid early stoppage.
sed -i "s/900/900000/" /usr/local/lib/python2.7/dist-packages/bibos_client/jobmanager.py

# Fix dpkg settings to avoid interactivity.
cat << EOF > /etc/apt/apt.conf.d/local

Dpkg::Options {
   "--force-confdef";
   "--force-confold";
}

EOF

do-release-upgrade -f DistUpgradeViewNonInteractive > /dev/null


