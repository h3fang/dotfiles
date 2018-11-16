#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# setup PRIME
#xrandr --setprovideroutputsource NVIDIA-0 modesetting
#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --setprovideroutputsource nouveau modesetting
#xrandr --setprovideroutputsource modesetting nouveau

# setup display
xrandr --auto --dpi 144
#xrandr --output eDP-1 --auto --dpi 144 --primary
#xrandr --output eDP1 --auto --dpi 144 --primary
#xrandr --output HDMI-1-2 --auto --right-of eDP1

# numlock
numlockx &

# gnome-keyring
dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID
#export SSH_AUTH_SOCK

# window manager or desktop environment
exec i3

