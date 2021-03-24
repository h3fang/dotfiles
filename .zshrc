export EDITOR='vim'
export LESSHISTFILE=/dev/null

setopt prompt_subst
PROMPT="%F{39}┌── [ %F{197}\${CONDA_DEFAULT_ENV:+\$CONDA_DEFAULT_ENV }%F{39}%n @ %m %F{201}%* %F{40}%~ %F{39}]
└── %# "

autoload -Uz compinit
mkdir -p "$XDG_CACHE_HOME/zsh" || true
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

setopt AUTO_CD

mkdir -p "$XDG_DATA_HOME/zsh" || true
HISTFILE=${XDG_DATA_HOME}/zsh/history
setopt EXTENDED_HISTORY
SAVEHIST=10000
HISTSIZE=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

setopt CORRECT
setopt CORRECT_ALL

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

alias cp2="rsync -ah --progress"
alias free='free -h'
alias df='df -h'
alias ls='ls --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias paclog='~/scripts/paclog.py'
alias music='mpv --volume=60 --shuffle --loop-playlist=inf --no-resume-playback --audio-display=no ~/Music/'
alias weather='curl -m 5 https://wttr.in?lang=zh'
alias ncdu='ncdu --color dark'
alias dot='/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'
alias miniconda='source ~/.local/miniconda3/bin/activate $(ls ~/.local/miniconda3/envs | fzf --reverse)'
alias yaySc="yay -Sc --noconfirm"
alias i3windows="i3-msg -t get_tree | jq '.. | select( .class?) | {class: .class, title: .title}'"
alias swaywindows="swaymsg -t get_tree | jq '.. | select( .class? or .app_id? ) | {class: .class, app_id: .app_id, title: .title}'"

