#!/bin/bash

# Find current directory

DIR=$(dirname ${BASH_SOURCE[0]})

# Step 1: Check for valid APT repositories.

apt-get update &> /dev/null
RET_VAL=$?
if [ $RET_VAL -ne 0 ]; then
    echo "" 1>&2
    echo "ERROR: Apt repositories are not valid or cannot be reached from your network." 1>&2
    echo "Please fix and retry" 1>&2
    echo "" 1>&2
    exit 1
else
    echo "Repositories OK: Installing packages"
fi

# Update and upgrade the system
apt-get -y upgrade | tee /tmp/os2borgerpc_upgrade_log.txt
apt-get -y dist-upgrade | tee /tmp/os2borgerpc_upgrade_log.txt


# Install OS2bogerPC specific dependencies
#
# The DEPENDENCIES file contains packages/programs
# required by OS2borgerPC AND extra packages which are free dependencies
# of Skype and MS Fonts - to shorten the postinstall process.
DEPENDENCIES=( $(cat "$DIR/DEPENDENCIES") )

PKGS_TO_INSTALL=""

dpkg -l | grep "^ii" > /tmp/installed-package-list.txt

for PKG in "${DEPENDENCIES[@]}"
do
    grep -w "ii  $PKG " /tmp/installed-package-list.txt > /dev/null
    if [[ $? -ne 0 ]]; then
        PKGS_TO_INSTALL=$PKGS_TO_INSTALL" "$PKG
    fi
done

if [ "$PKGS_TO_INSTALL" != "" ]; then
    echo  -n "Some dependencies are missing."
    echo " The following packages will be installed: $PKGS_TO_INSTALL"

    # Step 1: Check for valid APT repositories.

    apt-get update &> /dev/null
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Apt repositories are not valid or cannot be reached from your network." 1>&2
        echo "Please fix and retry" 1>&2
        echo "" 1>&2
        exit 1
    else
        echo "Repositories OK: Installing packages"
    fi

    # Step 2: Do the actual installation. Abort if it fails.
    # and install
    # shellcheck disable=SC2086 # We want word-splitting here
    apt-get -y install $PKGS_TO_INSTALL | tee /tmp/os2borgerpc_install_log.txt
    RET_VAL=$?
    if [ $RET_VAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Installation of dependencies failed." 1>&2
        echo "Please note that \"universe\" repository MUST be enabled" 1>&2
        echo "" 1>&2
        exit 1
    fi
fi

# Install os2borgerpc client
pip3 install os2borgerpc-client

# Install Danish language package
apt-get -y install language-pack-da language-pack-da-base

# Clean .deb cache to save space
apt-get -y autoremove
apt-get -y clean

# OS2borgerPC Kiosk specifics:

# Set Danish locale and timezone, e.g. for usage
# with Aula and attached/onscreen keyboards
timedatectl set-timezone Europe/Copenhagen
sed -i 's/# \(da_DK.UTF-8 UTF-8\)/\1/'  /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive tzdata
update-locale LANG=da_DK.utf-8

# Update the time accordingly
ntpdate pool.ntp.org
