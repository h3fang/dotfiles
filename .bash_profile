#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    if [[ -f ~/.local/share/xorg/Xorg.log ]]; then
        cp ~/.local/share/xorg/Xorg.log ~/.local/share/xorg/Xorg.log.old
    fi

    exec startx -- -keeptty > ~/.local/share/xorg/Xorg.log 2>&1
fi

