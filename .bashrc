#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias cp="rsync -ah --progress"
alias free='free -h'
alias df='df -h'
alias ls='ls --color=auto -l'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias paclog='vim /var/log/pacman.log'
alias pacilog='grep -E " installed (\w|-|\+)*" /var/log/pacman.log | grep -E "(\w|-|\+)* \("'
alias paculog='grep -E " upgraded (\w|-|\+)*" /var/log/pacman.log | grep -E "(\w|-|\+)* \("'
alias pacrlog='grep -E " removed (\w|-|\+)*" /var/log/pacman.log | grep -E "(\w|-|\+)* \("'
alias cls='printf "\033c"'
alias music='mpv --volume=60 --shuffle --loop-playlist=inf --no-resume-playback --audio-display=no ~/Music/'
alias weather='curl -m 5 https://wttr.in?lang=zh'
alias ncdu='ncdu --color dark'
alias dot='/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'
alias miniconda='source ~/.local/miniconda3/bin/activate main'
alias yaySc="yay -Sc --noconfirm"

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

conda_prompt() {
    if test -z "$CONDA_DEFAULT_ENV"
    then
        echo ""
    else
        echo "${CONDA_DEFAULT_ENV} "
    fi
}

#PS1='[\u@\h \W]\$ '
#PS1="\[\033[38;5;39m\][\u@\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;10m\]\W\[$(tput sgr0)\]\[\033[38;5;39m\]]\\$\[$(tput sgr0)\] "
PS1="\[\033[38;5;39m\]┌── [ \[\033[38;5;197m\]\$(conda_prompt)\[\033[38;5;39m\]\u @ \h \[$(tput sgr0)\]\[\033[38;5;201m\]\t \[$(tput sgr0)\]\[\033[38;5;10m\]\w \[$(tput sgr0)\]\[\033[38;5;39m\]]\n\[\033[38;5;39m\]└── \\$ \[$(tput sgr0)\]"

export VISUAL="vim"
export LESSHISTFILE=/dev/null

# HSTR configuration
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor,raw-history-view       # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignoreboth    # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between Bash memory and history file
export PROMPT_COMMAND="history -a; history -n"
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

tac ~/.bash_history | awk '!x[$0]++' | tac > /tmp/clean_bh; mv /tmp/clean_bh ~/.bash_history

