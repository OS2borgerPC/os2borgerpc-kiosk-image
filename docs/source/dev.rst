How to install and run OS2borgerPC Kiosk
****************************************

Install OS2borgerPC Kiosk image
-------------------------------

Get the most recent OS2borgerPC Kiosk image as provided by Magenta,
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

Remove the install media and reboot.

The login screen may contain output related to the upstart process:

.. image:: install_3.png

This is not a problem and you'll be able to login as the user ``superuser`` with password ``superuser``.


.. danger::
    Please change this password *immediately* after deploying each
    server!! There's a script in OS2borgerPC Admin to do this.



Getting internet access
-----------------------

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

Connect to OS2borgerPC-admin (our admin system)
-----------------------------------------------

Once you're connected to the network, enter the command::

    sudo os2borgerpc_kiosk_setup

This will install all dependencies for the OS2borgerPC client.


.. note::

    This may take some time.

Finally you'll be prompted for information to register the machine
with our admin system:

- ``gateway``: Just press "Enter" to skip.
- ``name``: Give the computer any valid name you like.
- ``site``: If hosted by us: Use the site name we should've e-mailed you. If self-hosting or developing: Create a site, and
  specify its name here.
- ``server``: If hosted by us: Just press enter. If self-hosting specify the domain of your server. For development its
  likely some port on localhost.

Setting up for Kiosk
--------------------

Once the computer is connected to the admin system and activated, you
may set it up to run as a kiosk machine.

There are two scripts needed to do this.

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

Additional remote access
------------------------

If you want additional remote access to this system, besides being able to run scripts
on it from the admin system, you can run the script called
"OS2borgerPC Kiosk  - Installer SSH og VNC". After this, you'll
be able to SSH to the machine and to see its display by connecting with
a VNC client.

.. danger::

    You *must* change the standard password before or *immediately*
    after running this script.

.. note::

    You use ``superuser``'s standard UNIX password to SSH. In order to
    connect with VNC, you need to supply a specific VNC password as a
    parameter for this script.
