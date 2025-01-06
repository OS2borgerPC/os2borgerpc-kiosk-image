#!/bin/bash

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

printf "%s\n" "Installs build dependencies on the HOST machine"

# Find current directory

export DEBIAN_FRONTEND=noninteractive
DEPENDENCIES=( p7zip-full rsync xorriso isolinux figlet fdisk)

PKGS_TO_INSTALL=""

dpkg -l | grep "^ii" > /tmp/build_installed_packages_list.txt

for PKG in "${DEPENDENCIES[@]}"
do
    grep -w "ii  $PKG " /tmp/build_installed_packages_list.txt > /dev/null
    if [[ $? -ne 0 ]]; then
        PKGS_TO_INSTALL=$PKGS_TO_INSTALL" "$PKG
    fi
done

if [ "$PKGS_TO_INSTALL" != "" ]; then
    echo  -n "Some dependencies are missing."
    echo " The following packages will be installed: $PKGS_TO_INSTALL"
    sudo apt-get update > /dev/null
    # shellcheck disable=SC2086 # We want word-splitting here
    sudo apt-get -y install $PKGS_TO_INSTALL
    RET_VAL=$?
    if [ $RET_VAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Installation of dependencies failed." 1>&2
        echo "Please note that \"universe\" repository MUST be enabled" 1>&2
        echo "" 1>&2
        exit 1
    fi

fi
