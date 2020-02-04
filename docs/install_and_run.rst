How to install and run the OS2display solution
==============================================

Install OS2borgerPC server image
--------------------------------

Get the most recent OS2borgerPC server image from the archive, e.g.

http://bibos-admin.magenta-aps.dk/archive/os2borgerpc-server-0.1.0.iso

Burn the image to a USB or DVD and boot the target computer with it.

In the bootup menu, choose the first option, "Install Ubuntu Server for
OS2display".

This installation procedure will not ask a lot of questions, but it will
ask where and how to install the operating system. Choose your primary
harddisk, ``/dev/sda`` in most cases.

The image will work with UEFI boot, but legacy boot is also supported.
If using legacy boot, the installer may ask you where to install the
GRUB bootloader. Enter the path of your primary harddisk (again,
``/dev/sda`` in most cases) - if you don't enter anything, the system
will not work.

Reboot. You'll be able to login as the user ``superuser`` with password
``superuser``.


.. danger:: 
    Please change this password *immediately* after deploying each
    server!! There's a script in OS2borgerPC Admin to do this.


Getting network
---------------

If you installed with an Ethernet cable and a DHCP-enabled network, the
computer is already online. If you need to set up wireless network or
configure a static IP, enter the following command::

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

    os2borgerpc_server_setup

This will install all dependencies for the OS2borgerPC client and
connect to the admin system.

.. note::

    This may take some time.



Setting up for OS2display
-------------------------

Once the computer is connected to the admin system and activated, you
may deploy OS2display to it.

In the admin system, we have introduced three global scripts with the
prefix "OS2displayOS".

The first is called "OS2DisplayOS  - Installer Chromium" and will
install the browser and setup minimum GUI capabilities. 

When this script has run successfully, you can configure Chromium to
start automatically on boot and configure the start URL and time delay
as needed. You do this by running the script called "OS2displayOS - Autostart
Chromium".

In order to have remote access to this system, you need to run the
script called "OS2displayOS  - Installer SSH og VNC". After this, you'll
be able to SSH to the machine and to see its display by connecting with
a VNC client.

.. danger::

    You *must* change the standard password before or *immediately*
    after running this script.


