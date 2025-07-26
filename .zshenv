typeset -U path PATH

# XDG Base Directory
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}"/zsh
export XAUTHORITY="$XDG_CACHE_HOME"/Xauthority
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export TEXMFHOME="$XDG_DATA_HOME"/texmf
export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var
export TEXMFCONFIG="$XDG_CONFIG_HOME/"texlive/texmf-config
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet

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

# rust
export RUSTUP_DIST_SERVER=https://rsproxy.cn
export PATH="$PATH:$CARGO_HOME/bin"

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="-1 --no-mouse --reverse --multi --inline-info"

# misc.
export VISUAL='nvim'
export EDITOR='nvim'
export LESSHISTFILE=/dev/null
export EXA_COLORS='da=38;5;33'
