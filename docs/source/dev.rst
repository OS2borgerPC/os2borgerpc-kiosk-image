Technical Documentation
=======================

How to install and run OS2borgerPC Kiosk
****************************************

Install OS2borgerPC server image
--------------------------------

Get the most recent OS2borgerPC server image as provided by Magenta,
or build one yourself according to the instructions in the ``image``
directory.


Copy the image to a USB or DVD and boot the target computer with it.


The image will work with UEFI boot, but legacy boot is also supported.

The installation procedure will not ask a lot of questions. First of
all, it will ask you to choose a language for the installation, as shown
below:

.. image:: install_1.png

Unfortunately, Danish is currently not supported. Hit ENTER to keep
"English".

Next, specify the disk you will install on, as shown below:

.. image:: install_2.png

If you're installing on a normal setup with only one hard disk attached,
the defaults will be fine - in that case, hit TAB until you reach "Done"
and hit ENTER. Otherwise, specify disk and partitions according to your
needs. 

As this will destroy all data in the disk in question, you will now be
asked to "Confirm destructive action". To proceed, select "Continue".

.. warning::  This step *will* destroy all data on the disk you install on.

The system will now install - this will take some time.

Remove the install media and reboot. You'll be able to login as the user
``superuser`` with password ``superuser``.


.. danger:: 
    Please change this password *immediately* after deploying each
    server!! There's a script in OS2borgerPC Admin to do this.



Getting network
---------------

If you installed with an Ethernet cable and a DHCP-enabled network, the
computer is already online. If you need to set up wireless network or
configure a static IP, you must first install basic wireless
capabilities - these are not installed by default. You don't need a
network connection, just enter the command::

    sudo wifi_setup

.. note:: If you don't need to use a wireless connection or do any
    other special network setup like setting up a static IP address,
    there is no need to execute this command.

With this in place, enter the following command::

    nmtui

To connect to a new network choose "Activate a connection" in the menu.
If everything works as it should and the computer has a wireless card,
you will see a list of wireless networks (if any exist, of course).

If you're already connected, e.g. through Ethernet, choose "Edit a
Connection". You can now setup static IP, etc.

.. note:: 

    In some cases, the wireless cards will not work properly unless the
    computer is connected through Ethernet during installation. We
    recommend that you install with an Internet-enabled Ethernet connection,
    though in some cases it will also work without it - it depends on
    your specific wireless card.

Connect to OS2borgerPC admin
----------------------------

Once you're connected to the network, enter the command::

    sudo os2borgerpc_server_setup

This will install all dependencies for the OS2borgerPC client and
connect to the admin system.

.. note::

    This may take some time.



Setting up for Kiosk
--------------------

Once the computer is connected to the admin system and activated, you
may set it up to run as a kiosk.

In the admin system, we have introduced three global scripts with the
prefix "OS2borgerPC Kiosk".

The first is called "OS2borgerPC Kiosk  - Installer Chromium" and will
install the browser and setup minimum GUI capabilities. 

When this script has run successfully, you can configure Chromium to
start automatically on boot and configure the start URL and time delay
as needed. You do this by running the script called "OS2borgerPC Kiosk - Autostart
Chromium".

In this script, you must specify the following four parameters:

* ``time`` - a delay time before Chromium is started.
* ``url`` - the start URL for your kiosk, e.g. an OS2display site.
* ``width`` - the width (X) component of the desired screen resolution, e.g.
  "1980".
* ``height`` - the height component of the desired screen resolution, e.g.
  "1080".
* ``orientation`` - the orientation or rotation of the screen. Values
  must be one of ``normal``, ``right`` or ``left``. If this parameter is
  misspelled, the system will default to "normal".

The width and height parameters must correspond to the preferred
(maximum) screen resolution of your monitor.

In order to have remote access to this system, you need to run the
script called "OS2borgerPC Kiosk  - Installer SSH og VNC". After this, you'll
be able to SSH to the machine and to see its display by connecting with
a VNC client.

.. danger::

    You *must* change the standard password before or *immediately*
    after running this script.

.. note::

    You use ``superuser``'s standard UNIX password to SSH. In order to
    connect with VNC, you need to supply a specific VNC password as a
    parameter for this script.


How to build the OS2borgerPC Kiosk ISO image
********************************************

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

The ``wifi_setup`` script currently expect such packages to exist in the
directory ``scripts/wifi`` - as we need to be able to set up wifi
without a network connection, while we should, a the same time, never
enable wifi unless we know that it's necessary.

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

    xorriso -as mkisofs -r   -V os2borgerpc_kiosk   -o os2borgerpc_kiosk-1.0.0rc1.iso   -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot   -boot-load-size 4 -boot-info-table   -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot   -isohybrid-gpt-basdat -isohybrid-apm-hfsplus   -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin iso/boot iso

where "os2borgerpc_kiosk" and "os2borgerpc_kiosk-1.0.0rc1.iso" should be replaced
by what you wish the tag and filename of the ISO image to be.

You'll need to install the necessary dependencies to create the ISO - on
Ubuntu 20.04, it can be done with: ::

    sudo apt-get install xorriso isolinux
