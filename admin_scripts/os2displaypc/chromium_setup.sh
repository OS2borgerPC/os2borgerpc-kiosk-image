#!/bin/bash
# Make Chromium  autostart and set it up with OS2Display.

# Initialize parameters

TIME=$1
URL=$2
WIDTH=$3
HEIGHT=$4
ORIENTATION=$5

# Setup Chromium user
useradd chrome -m -p 12345 -s /bin/bash -U
chfn -f Chrome chrome

# Autologin default user

mkdir -p /etc/systemd/system/getty@tty1.service.d

cat << EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin chrome %I $TERM
Type=idle
EOF

# Create script to rotate screen

cat << EOF > /usr/local/bin/rotate_screen.sh
#!/usr/bin/env bash
set -x

sleep $TIME

export XAUTHORITY=/home/chrome/.Xauthority
# Rotate screen
active_monitors=(\$(xrandr --listactivemonitors -display :0 | grep -v Monitors | awk '{ print \$4; }'))
# If more than one monitor, rotate them all.

for m in "\${active_monitors[@]}"
do
    xrandr --output \$m --rotate $ORIENTATION -display :0
done

EOF

chmod +x /usr/local/bin/rotate_screen.sh &

# Launch chrome upon startup

cat << EOF > /home/chrome/.xinitrc
#!/bin/sh

# xset -dpms
xset s off
xset s noblank

sleep 20

# sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/chrome/.config/chromium/Default/Preferences

# sed -i 's/"exit_type":"Crashed"/"exit_type":"None"/' /home/chrome/.config/chromium/Default/Preferences

# sed -i 's/"restore_on_startup":[0-9]/"restore_on_startup":0/' /home/chrome/.config/chromium/Default/Preferences

/usr/local/bin/rotate_screen.sh

exec chromium-browser --kiosk $URL --window-size=$WIDTH,$HEIGHT --window-position=0,0 --password-store=basic --autoplay-policy=no-user-gesture-required --disable-translate --enable-offline-auto-reload
EOF


echo "startx" >> /home/chrome/.profile
