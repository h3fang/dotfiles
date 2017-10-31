#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto -l'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias pacilog='cat /var/log/pacman.log | grep "pacman \-S \w"'
alias paculog='cat /var/log/pacman.log | grep "upgraded \w"'
alias pacrlog='cat /var/log/pacman.log | grep "pacman \-R"'
alias pacopt='pacaur -Sc && sudo pacman-optimize'
alias pacsyu='pacaur -Syu'

# SJTU IPTV
alias cctv5='mpv --fs --no-resume-playback --no-ytdl http://202.120.58.89/hls/cctv5hd.m3u8'
alias cctv5n='mpv --fs --no-resume-playback --no-ytdl http://202.120.58.89/hls/cctv5.m3u8'
alias cctv5p='mpv --fs --no-resume-playback --no-ytdl http://202.120.58.89/hls/cctv5phd.m3u8'
alias cctv6='mpv --fs --no-resume-playback --no-ytdl http://202.120.58.89/hls/cctv6hd.m3u8'
alias cctv6n='mpv --fs --no-resume-playback --no-ytdl http://202.120.58.89/hls/cctv6.m3u8'

export HISTCONTROL=ignoredups:erasedups

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

#PS1='[\u@\h \W]\$ '
#PS1="\[\033[38;5;4m\][\[$(tput sgr0)\]\[\033[38;5;4m\]\u@\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;10m\]\W\[$(tput sgr0)\]\[\033[38;5;4m\]]\\$\[$(tput sgr0)\] "
PS1="\[\033[38;5;39m\][\u@\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;10m\]\W\[$(tput sgr0)\]\[\033[38;5;39m\]]\\$\[$(tput sgr0)\] "

export VISUAL="vim"

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
    eval "$(<~/.ssh-agent-thing)" > /dev/null
    ssh-add
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)" > /dev/null
fi
