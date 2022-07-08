#! /usr/bin/env sh

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

ISO_PATH=$1
TARGET_DIR=$2

# Extract ISO:
mkdir --parents "$TARGET_DIR"
7z x "$ISO_PATH" -o"$TARGET_DIR"
rm -rf "$TARGET_DIR/[BOOT]/"
# Excludes are relative to source dir, not CWD
rsync -r ubuntu-image/* "$TARGET_DIR"

md5sum "$TARGET_DIR/.disk/info" > "$TARGET_DIR/md5sum.txt"
sed -i 's|iso/|./|g' "$TARGET_DIR/md5sum.txt"
