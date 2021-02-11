[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/scripts/envs ]] && . ~/scripts/envs

[[ -f ~/.bash_history ]] && tac ~/.bash_history | awk '!x[$0]++' | tac > ~/.bash_history

start_i3wm() {
    if [[ -L "$GTK2_RC_FILES" ]]; then
        \rm "$GTK2_RC_FILES"
        ln -s "${GTK2_RC_FILES}-i3" "$GTK2_RC_FILES"
    fi
    X_LOG_DIR=~/.local/share/xorg
    mkdir -p $X_LOG_DIR
    X_SESSION_LOG=$X_LOG_DIR/xsession.$XDG_VTNR.log
    if [[ -f $X_SESSION_LOG ]]; then
        \cp $X_SESSION_LOG ${X_SESSION_LOG}.old
    fi

    export QT_AUTO_SCREEN_SCALE_FACTOR=0
    export MOZ_X11_EGL=1
    exec startx -- -keeptty > $X_SESSION_LOG 2>&1
}

start_sway() {
    if [[ -L "$GTK2_RC_FILES" ]]; then
        \rm "$GTK2_RC_FILES"
        ln -s "${GTK2_RC_FILES}-sway" "$GTK2_RC_FILES"
    fi
    SWAY_LOG_DIR=~/.local/share/sway
    mkdir -p $SWAY_LOG_DIR
    SWAY_LOG=$SWAY_LOG_DIR/sway.$XDG_VTNR.log
    if [[ -f $SWAY_LOG ]]; then
        \cp $SWAY_LOG ${SWAY_LOG}.old
    fi

    XKB_DEFAULT_LAYOUT=us \
    XDG_SESSION_TYPE=wayland \
    QT_QPA_PLATFORM=wayland \
    QT_WAYLAND_FORCE_DPI=physical \
    QT_FONT_DPI=${SCREEN_DPI:-144} \
    SDL_VIDEODRIVER=wayland \
    _JAVA_AWT_WM_NONREPARENTING=1 \
    MOZ_ENABLE_WAYLAND=1 \
    exec sway > $SWAY_LOG 2>&1
}

export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

export XAUTHORITY="$XDG_CACHE_HOME"/Xauthority
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=DEFAULT=fcitx

export ELECTRON_TRASH=gio

ncores=$(cat /proc/cpuinfo | grep -m 1 'cpu cores' | awk '{print $4}')
export OPENBLAS_NUM_THREADS=$ncores
export GOTO_NUM_THREADS=$ncores
export OMP_NUM_THREADS=$ncores

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    start_i3wm
elif [[ ! $DISPLAY && $XDG_VTNR -eq 2 ]]; then
    start_sway
fi

