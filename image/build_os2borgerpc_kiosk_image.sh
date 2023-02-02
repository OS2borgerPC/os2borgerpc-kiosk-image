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
    sudo rm -rf iso /tmp/build_installed_packages_list.txt scripts/wifi/*.deb boot_hybrid.img ubuntu22-server-amd64.efi
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

mbr="boot_hybrid.img"

efi="ubuntu22-server-amd64.efi"

# Extract the MBR template

dd if="$ISO_PATH" bs=1 count=446 of=$mbr

# Extract EFI partition image

skip=$(/sbin/fdisk -l "$ISO_PATH" | grep -F '.iso2 ' | awk '{print $2}')

size=$(/sbin/fdisk -l "$ISO_PATH" | grep -F '.iso2 ' | awk '{print $4}')

dd if="$ISO_PATH" bs=512 skip="$skip" count="$size" of=$efi

xorriso -as mkisofs -r   -V "$IMAGE_NAME" -o "$IMAGE_NAME".iso   -J -joliet-long -l -iso-level 3 \
    -partition_offset 16 --grub2-mbr $mbr --mbr-force-bootable -append_partition 2 0xEF $efi \
    -appended_part_as_gpt -c boot.catalog -b boot/grub/i386-pc/eltorito.img -no-emul-boot \
    -boot-load-size 4 -boot-info-table --grub2-boot-info  -eltorito-alt-boot \
    -e '--interval:appended_partition_2:all::' -no-emul-boot iso

if [ $? = 0 ]; then
    echo "$IMAGE_NAME.iso was successfully created"
fi
