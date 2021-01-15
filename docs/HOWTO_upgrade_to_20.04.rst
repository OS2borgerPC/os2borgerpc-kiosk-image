Upgrade OS2displayPC from Ubuntu 16.04 to 20.04
===============================================

This process consists, for each computer, of the following steps:

1) Run the script "OS2DisplayPC opdater til Ubuntu 20.04 (1)" on the target
computer. This will reboot the computer and leave the job in state
"Afsendt".

2) Now run the script "OS2DisplayPC opdater til Ubuntu 20.04 (2)" on the
target computer. This will take some time - do not send further commands
until the job has succeeded and is seen to be in state "Udført".

3) Reboot the computer by running the script "System - Genstart
computeren". 

4) Run the script "OS2DisplayPC opdater til Ubuntu 20.04 (3)". Once
again, this will take some time, and you should wait until the job has
succeeded and is seen to be in state "Udført".

5) Reboot the computer as in 3) - after restart, the upgrade to Ubuntu
20.04 is complete.
