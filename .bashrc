#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias cp2="rsync -ah --progress"
alias free='free -h'
alias df='df -h'
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias paclog='vim /var/log/pacman.log'
alias pacilog='grep -E " installed (\w|-|\+)*" /var/log/pacman.log | grep -E "(\w|-|\+)* \("'
alias paculog='grep -E " upgraded (\w|-|\+)*" /var/log/pacman.log | grep -E "(\w|-|\+)* \("'
alias pacrlog='grep -E " removed (\w|-|\+)*" /var/log/pacman.log | grep -E "(\w|-|\+)* \("'
alias music='mpv --volume=60 --shuffle --loop-playlist=inf --no-resume-playback --audio-display=no ~/Music/'
alias weather='curl -m 5 https://wttr.in?lang=zh'
alias ncdu='ncdu --color dark'
alias dot='/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'
alias miniconda='source ~/.local/miniconda3/bin/activate $(echo -e "base\n$(ls ~/.local/miniconda3/envs)" | fzf)'
alias yaySc="yay -Sc --noconfirm"
alias i3windows="i3-msg -t get_tree | jq '.. | select( .class?) | {class: .class, title: .title}'"
alias swaywindows="swaymsg -t get_tree | jq '.. | select( .class? or .app_id? ) | {class: .class, app_id: .app_id, title: .title}'"
alias scripts='$(fd -t x . ~/scripts/ | fzf)'

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

set_bash_ps1() {
    local B="\[\033[38;5;39m\]" # blue
    local R="\[\033[38;5;197m\]" # red
    local P="\[\033[38;5;201m\]" # purple
    local G="\[\033[38;5;10m\]" # green
    local Y="\[\033[38;5;11m\]" # yellow

    local uhc="$B"
    [[ -n $SSH_CLIENT ]] && uhc="$Y"

    #PS1='[\u@\h \W]\$ '
    PS1="${B}┌── [ ${R}\${CONDA_DEFAULT_ENV:+\$CONDA_DEFAULT_ENV }${uhc}\u @ \h ${P}\t ${G}\w ${B}]\n${B}└── \\$ \[$(tput sgr0)\]"
}

set_bash_ps1

export VISUAL="vim"
export LESSHISTFILE=/dev/null

# HSTR configuration
export HSTR_CONFIG=hicolor,raw-history-view       # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignoreboth    # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between Bash memory and history file
export PROMPT_COMMAND='history -a; history -n'
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="-1 --no-mouse --reverse --multi --inline-info"
