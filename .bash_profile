[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.bash_history ]] && echo "$(tac ~/.bash_history | awk '!x[$0]++' | tac)" > ~/.bash_history

### environment variables
[[ -f ~/scripts/envs ]] && . ~/scripts/envs

export VISUAL='nvim'
export EDITOR='nvim'
export LESSHISTFILE=/dev/null
export EXA_COLORS='da=38;5;33'

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="-1 --no-mouse --reverse --multi --inline-info"

# XDG Base Directory
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

export XAUTHORITY="$XDG_CACHE_HOME"/Xauthority
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# GPG
export GPG_TTY=$(tty)

# fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

# Electron trash
export ELECTRON_TRASH=gio

### keyring
export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

### WM start up functions
start_i3wm() {
    if [[ -L "$GTK2_RC_FILES" ]]; then
        \rm "$GTK2_RC_FILES"
        \ln -s "${GTK2_RC_FILES}-i3" "$GTK2_RC_FILES"
    fi
    X_LOG_DIR=~/.local/share/xorg
    \mkdir -p "$X_LOG_DIR"
    X_SESSION_LOG=$X_LOG_DIR/xsession.$XDG_VTNR.log
    if [[ -f $X_SESSION_LOG ]]; then
        \cp "$X_SESSION_LOG" "${X_SESSION_LOG}.old"
    fi

    export XDG_SESSION_TYPE=x11
    export QT_AUTO_SCREEN_SCALE_FACTOR=0
    export MOZ_X11_EGL=1
    exec startx -- -keeptty > "$X_SESSION_LOG" 2>&1
}

start_sway() {
    if [[ -L "$GTK2_RC_FILES" ]]; then
        \rm "$GTK2_RC_FILES"
        \ln -s "${GTK2_RC_FILES}-sway" "$GTK2_RC_FILES"
    fi
    SWAY_LOG_DIR=~/.local/share/sway
    \mkdir -p $SWAY_LOG_DIR
    SWAY_LOG=$SWAY_LOG_DIR/sway.$XDG_VTNR.log
    if [[ -f $SWAY_LOG ]]; then
        \cp "$SWAY_LOG" "${SWAY_LOG}.old"
    fi

    XKB_DEFAULT_LAYOUT=us \
    XDG_SESSION_TYPE=wayland \
    QT_QPA_PLATFORM=wayland \
    QT_WAYLAND_FORCE_DPI=physical \
    QT_AUTO_SCREEN_SCALE_FACTOR=0 \
    SDL_VIDEODRIVER=wayland \
    _JAVA_AWT_WM_NONREPARENTING=1 \
    MOZ_ENABLE_WAYLAND=1 \
    exec sway > "$SWAY_LOG" 2>&1
}

### Window Manager
if [[ "$(tty)" = "/dev/tty2" ]]; then
    start_i3wm
elif [[ "$(tty)" = "/dev/tty1" ]]; then
    start_sway
fi

