#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    X_SESSION_LOG=~/.local/share/xorg/xsession.log
    if [[ -f $X_SESSION_LOG ]]; then
        cp $X_SESSION_LOG ${X_SESSION_LOG}.old
    fi

    exec startx -- -keeptty > $X_SESSION_LOG 2>&1
fi

