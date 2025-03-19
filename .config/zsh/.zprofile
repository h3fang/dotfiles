### environment variables

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
export XDG_STATE_HOME=~/.local/state

export XAUTHORITY="$XDG_CACHE_HOME"/Xauthority
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export TEXMFHOME="$XDG_DATA_HOME"/texmf
export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var
export TEXMFCONFIG="$XDG_CONFIG_HOME/"texlive/texmf-config
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# GPG
export GPG_TTY="$(tty)"

# fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

# Electron trash
export ELECTRON_TRASH=gio

# keyring
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/gcr/ssh

# GTK
export NO_AT_BRIDGE=1
export GTK_A11Y=none

# Qt
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_FONT_DPI=96

# SDL
export SDL_AUDIODRIVER=pipewire

systemctl --user import-environment XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

### Window Manager

start_sway() {
    SWAY_LOG_DIR=~/.local/share/sway
    mkdir -p $SWAY_LOG_DIR
    SWAY_LOG=$SWAY_LOG_DIR/sway.$XDG_VTNR.log
    if [[ -f $SWAY_LOG ]]; then
        cp "$SWAY_LOG" "${SWAY_LOG}.old"
    fi

    XDG_SESSION_TYPE=wayland \
    XDG_CURRENT_DESKTOP="sway:wlroots" \
    QT_QPA_PLATFORM="wayland;xcb" \
    QT_WAYLAND_FORCE_DPI=physical \
    _JAVA_AWT_WM_NONREPARENTING=1 \
    MOZ_ENABLE_WAYLAND=1 \
    exec sway > "$SWAY_LOG" 2>&1
}

if [[ "$(tty)" = "/dev/tty1" ]]; then
    start_sway
fi

