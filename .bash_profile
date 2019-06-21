#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/scripts/envs ]] && . ~/scripts/envs

start_i3wm() {
    X_LOG_DIR=~/.local/share/xorg
    mkdir -p $X_LOG_DIR
    X_SESSION_LOG=$X_LOG_DIR/xsession.log
    if [[ -f $X_SESSION_LOG ]]; then
        /usr/bin/cp $X_SESSION_LOG ${X_SESSION_LOG}.old
    fi

    exec startx -- -keeptty > $X_SESSION_LOG 2>&1
}

start_sway() {
    SWAY_LOG_DIR=~/.local/share/sway
    mkdir -p $SWAY_LOG_DIR
    SWAY_LOG=$SWAY_LOG_DIR/sway.log
    if [[ -f $SWAY_LOG ]]; then
        /usr/bin/cp $SWAY_LOG ${SWAY_LOG}.old
    fi

    XDG_SESSION_TYPE=wayland \
    QT_QPA_PLATFORM=xcb \
    QT_WAYLAND_FORCE_DPI=physical \
    QT_FONT_DPI=144 \
    SDL_VIDEODRIVER=wayland \
    _JAVA_AWT_WM_NONREPARENTING=1 \
    MOZ_ENABLE_WAYLAND=1 \
    exec sway > $SWAY_LOG 2>&1
}

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    start_i3wm
elif [[ $XDG_VTNR -eq 2 ]]; then
    start_sway
fi

