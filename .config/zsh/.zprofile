systemctl --user import-environment XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

start_sway() {
    SWAY_LOG_DIR=~/.local/share/sway
    mkdir -p $SWAY_LOG_DIR
    SWAY_LOG=$SWAY_LOG_DIR/sway.$XDG_VTNR.log
    if [[ -f $SWAY_LOG ]]; then
        cp "$SWAY_LOG" "${SWAY_LOG}.old"
    fi

    XDG_SESSION_TYPE=wayland \
    XDG_CURRENT_DESKTOP="sway:wlroots" \
    QT_QPA_PLATFORM="wayland;xcb" \
    QT_WAYLAND_FORCE_DPI=physical \
    _JAVA_AWT_WM_NONREPARENTING=1 \
    MOZ_ENABLE_WAYLAND=1 \
    exec sway > "$SWAY_LOG" 2>&1
}

if [[ "$(tty)" = "/dev/tty1" ]]; then
    start_sway
fi

