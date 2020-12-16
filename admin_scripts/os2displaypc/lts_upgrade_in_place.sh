#!/bin/bash

cat << EOF > /etc/apt/apt.conf.d/local

Dpkg::Options {
   "--force-confdef";
   "--force-confold";
}

EOF

do-release-upgrade -f DistUpgradeViewNonInteractive


