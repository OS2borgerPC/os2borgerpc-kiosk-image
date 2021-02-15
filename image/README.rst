In order to build the ISO image, use a Ubuntu 20.04 Server Edition
installation CD and basically follow the instructions on this page:

https://gist.github.com/s3rj1k/55b10cd20f31542046018fcce32f103e

For more info about autoinstall, see this page:

https://ubuntu.com/server/docs/install/autoinstall

Basically, go to the directory where you wish to build the ISO, get the
installation ISO and unpack it: ::

   wget http://releases.ubuntu.com/focal/ubuntu-20.04.1-live-server-amd64.iso

   # Extract ISO:
   mkdir iso
   7z x ubuntu-20.04.1-live-server-amd64.iso -oiso
   rm -rf 'iso/[BOOT]/'
   cp -r /path/to/image/ubuntu-image/* iso

   md5sum iso/README.diskdefines > iso/md5sum.txt
   sed -i 's|iso/|./|g' iso/md5sum.txt



Now you can make any modifications you want, e.g. to the install process in
``nocloud/user-data`` or to the boot instructions in ``isolinux`` or
``boot/grub``.

Special customizations are best handled through ``late_commands`` in
``nocloud/user-data``.

If you need to include extra packages in the ISO, one way to do it is to
include the packages (``.deb`` files) in a bespoke directory in the ISO
and install them directly with ``dpkg -i``, either in a ``late_command``
or using a script.

Alternatively, you could make them officially part of the image by
adding them in ``pool/extras``.  This, however, requires you to unsquash
the embedded ``squashfs`` file system, update the package lists,
re-squash it and sign it. You must also compile a new version of the
``ubuntu-keyring`` package to include your own GPG signing key.

If you need to do this, you can find instructions on doing so here:

https://help.ubuntu.com/community/InstallCDCustomization

If you *did* add debs to ``pool/extras``, please note:

* To generate a new ``filesystem.squashfs``, you must first unpack it
  with unsquashfs - the directory you get from that is where you put the
  updated keyrings.

* Delete the old filesystem.squashfs before rebuilding it with
  mksquashfs, otherwise your changes are written to new paths with "_1"
  appended.

* Do not worry about  ``dpkg-scanpackages``, just follow the instructions
  for ``apt-ftparchive`` and you're good.

Once you're ready to create the ISO image for installation, run: ::

    xorriso -as mkisofs -r   -V os2displaypc   -o os2displaypc-1.0.0rc1.iso   -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot   -boot-load-size 4 -boot-info-table   -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot   -isohybrid-gpt-basdat -isohybrid-apm-hfsplus   -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin iso/boot iso

where "os2displaypc" and "os2displaypc-1.0.0rc1.iso" should be replaced
by what you wish the tag and filename of the ISO image to be.

You'll need to install the necessary dependencies to create the ISO - on
Ubuntu 20.04, it can be done with: ::

    sudo apt-get install xorriso isolinux
