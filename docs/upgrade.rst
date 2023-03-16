Upgrade OS2borgerPC Kiosk from Ubuntu 16.04 to 20.04
====================================================

This process consists, for each computer, of the following steps:

1. Run these scripts in any order on the target computer.
   You don't have to wait for one to finish before you run the next one:

   * **OS2borgerPC - Hook support**
   * | **OS2borgerPC hook - Beskyt konfiguration**
     | Use the parameter "ja".
   * | **OS2borgerPC hook - Etablér netforbindelse før tjek-ind**
     | Use the parameter "ja".

2. Run the script **OS2borgerPC Kiosk - Opdater til Ubuntu 20.04 (1)** on the target
computer. This will reboot the computer and leave the job in state
*Afsendt*.

3. Now run the script **OS2borgerPC Kiosk - Opdater til Ubuntu 20.04 (2)** on the
target computer. This will take some time - do not send further commands
until the job has succeeded and is seen to be in state *Udført*.

4. Reboot the computer by running the script **System - Genstart computeren**.

5. Run the script **OS2borgerPC Kiosk - Opdater til Ubuntu 20.04 (3)**. Once
again, this will take some time, and you should wait until the job has
succeeded and is seen to be in state *Udført*.

6. Reboot the computer as in 4).

7. Run the script **OS2borgerPC Kiosk - Opdater til Ubuntu 20.04 (4)**. This
will *not* take a long time, the OS upgrade is done by now.

8. Reboot the computer as in 4) and 6) - after restart, the upgrade to Ubuntu
20.04 is complete.
