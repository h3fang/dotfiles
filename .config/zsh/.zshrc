# completion

setopt complete_aliases
autoload -Uz compinit
mkdir -p "$XDG_CACHE_HOME/zsh"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# history

mkdir -p "$XDG_DATA_HOME/zsh"
HISTFILE=${XDG_DATA_HOME}/zsh/history
setopt EXTENDED_HISTORY
HISTSIZE=50000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# corrections

setopt CORRECT

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

# key bindings

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -e
bindkey -M emacs "${terminfo[khome]}" beginning-of-line
bindkey -M emacs "${terminfo[kend]}"  end-of-line
bindkey -M emacs "${terminfo[kdch1]}" delete-char
bindkey -M emacs '^U' backward-kill-line

source /usr/share/fzf/key-bindings.zsh
bindkey -r '^T'

# plugins

source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# prompt

eval "$(starship init zsh)"
