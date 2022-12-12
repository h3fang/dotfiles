#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias
alias cat='bat -pp'
alias cp2='rsync -ah --progress'
alias df='df -h'
alias diff='diff --color=auto'
alias dot='/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'
alias free='free -h'
alias grep='grep --color=auto'
alias ll='exa -l'
alias ls='exa'
alias miniconda='source ~/.local/miniconda3/bin/activate $(echo -e "base\n$(ls ~/.local/miniconda3/envs)" | fzf)'
alias music='mpv --volume=60 --shuffle --loop-playlist=inf --no-resume-playback --audio-display=no ~/Music/'
alias ncdu='ncdu --color dark'
alias rm='trash-put'
alias vim='nvim'
alias weather='curl -m 5 "https://wttr.in/${LOCATION_CITY}?lang=zh&format=v2"'
alias yaySc='yay -Sc --noconfirm'
alias wifi='wpa_cli -i $(ls /sys/class/ieee80211/*/device/net/ | fzf) select_network $(wpa_cli -i wlan0 list_networks | tail -n +2 | fzf | awk "{print $1}")'
alias gitgc='git reflog expire --expire=now --all && git gc --prune=now'

# functions
windows() {
    if ! command -v pgrep > /dev/null ; then
        echo "pgrep could not be found"
        return 1
    fi
    if pgrep -x sway > /dev/null ; then
        swaymsg -t get_tree | jq -r '..|objects|select(has("shell"))|{shell: .shell, name: .name, app_id: .app_id, window_properties: .window_properties}'
    elif pgrep -x i3 > /dev/null ; then
        i3-msg -t get_tree | jq -r '..|objects|select(has("window_properties"))|.window_properties'
    fi
}

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# HSTR configuration
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignoreboth    # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between Bash memory and history file
export PROMPT_COMMAND='history -a; history -n'

source /usr/share/fzf/key-bindings.bash

# completion for git alias
if [[ -r /usr/share/bash-completion/completions/git ]]; then
    . /usr/share/bash-completion/completions/git
    __git_complete dot __git_main
fi

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="-1 --no-mouse --reverse --multi --inline-info"

# starship
eval "$(starship init bash)"

