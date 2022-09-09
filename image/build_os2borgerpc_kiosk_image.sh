#! /usr/bin/env bash

ISO_PATH=$1
IMAGE_NAME=$2
CLEAN_BUILD=$3

pushd .

if [[ -z $ISO_PATH || -z $IMAGE_NAME ]]
then
    echo -e "Usage: $0 iso_file image_name [--clean]\n"
    echo "iso_file must be a valid path to the ISO file to be remastered"
    echo "image_name is the name of the output image"
    echo -e "clean: pass --clean to first delete temp build files, e.g. from within iso/\n"
    exit 1
fi

figlet "Building OS2borgerPC Kiosk"

set -ex

if [ "$CLEAN_BUILD" = "--clean" ]
then
    # Note: If testing locally maybe comment this next line out and use the subsequent one instead, so wifi deps are kept
    sudo rm -rf iso /tmp/build_installed_packages_list.txt scripts/wifi/*.deb
    # sudo rm -rf iso /tmp/build_installed_packages_list.txt
fi

build/install_dependencies.sh

build/extract_iso.sh "$ISO_PATH" iso

cd iso/scripts/wifi || exit 1
# These are downloaded from the host system currently, so maybe it needs to be built from a machine that's the same version of
# Ubuntu as the target?
# Note: If testing locally consider commenting out these two to make the build process a bit faster
sudo apt-get install --download-only --assume-yes network-manager language-pack-da
sudo apt download $(tr '\n' ' ' < deps.txt)

popd

xorriso -as mkisofs -r   -V "$IMAGE_NAME"   -o "$IMAGE_NAME.iso"   -J -l -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -no-emul-boot   -boot-load-size 4 -boot-info-table   -eltorito-alt-boot \
    -e boot/grub/efi.img -no-emul-boot   -isohybrid-gpt-basdat -isohybrid-apm-hfsplus   \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin iso/boot iso

if [ $? = 0 ]; then
    echo "$IMAGE_NAME.iso was successfully created"
fi
