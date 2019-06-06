#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/scripts/envs ]] && . ~/scripts/envs

start_i3wm() {
    X_SESSION_LOG=~/.local/share/xorg/xsession.log
    if [[ -f $X_SESSION_LOG ]]; then
        /usr/bin/cp $X_SESSION_LOG ${X_SESSION_LOG}.old
    fi

    exec startx -- -keeptty > $X_SESSION_LOG 2>&1
}

start_sway() {
    XDG_SESSION_TYPE=wayland QT_WAYLAND_FORCE_DPI=physical exec sway
}

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID SSH_AUTH_SOCK

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    start_i3wm
elif [[ $XDG_VTNR -eq 2 ]]; then
    start_sway
fi

