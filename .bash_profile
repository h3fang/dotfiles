#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    if [[ -f ~/.local/share/xorg/Xorg.log ]]; then
        cp ~/.local/share/xorg/xsession.log ~/.local/share/xorg/xsession.log.old
    fi

    exec startx -- -keeptty > ~/.local/share/xorg/xsession.log 2>&1
fi

