#!/bin/bash
# requires borg, libsecret, libnotify, awk

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    notify-send "Backup data failed" "line: $1 command: $2"
    exit $3
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

export BORG_REPO="/backup/$USER/data"
export BORG_PASSCOMMAND="secret-tool lookup borgrepo default"

if [[ ! -d $BORG_REPO ]]; then
    echo "Repo $BORG_REPO doesn't exist."
    notify-send -u critical "Backup" "Repo $BORG_REPO doesn't exist."
    exit 1
fi

borg create --compression auto,zstd,16 --stats --list --filter=AME \
    --exclude "$HOME/.config/blender/*/scripts/addons" \
    --exclude "$HOME/.config/borg/security" \
    --exclude "$HOME/.config/cef_user_data" \
    --exclude "$HOME/.config/Code" \
    --exclude "$HOME/.config/libreoffice" \
    --exclude "$HOME/.config/mpv/watch_later" \
    --exclude "$HOME/.config/GIMP" \
    --exclude "$HOME/.config/parallel/tmp" \
    --exclude "$HOME/.config/pulse" \
    --exclude "$HOME/.config/QtProject/qtcreator/qbs" \
    --exclude "$HOME/.config/QtProject/qtcreator/.helpcollection" \
    --exclude "$HOME/.config/fcitx5/conf/cached_layouts" \
    --exclude "$HOME/.config/ibus/bus" \
    --exclude "$HOME/.config/menus" \
    --exclude "$HOME/.config/transmission/resume" \
    --exclude "$HOME/.config/transmission/dht.dat" \
    --exclude "$HOME/.config/unity3d" \
    --exclude "$HOME/.ssh/known_hosts" \
    --exclude "sh:$HOME/projects/**/build-*" \
    --exclude "sh:$HOME/projects/**/[bB]uild" \
    --exclude "sh:$HOME/projects/**/target" \
    --exclude "sh:$HOME/projects/**/[dD]ata" \
    --exclude "sh:$HOME/projects/**/[rR]esults" \
    --exclude "sh:$HOME/projects/**/.godot" \
    --exclude "sh:$HOME/projects/**/.import" \
    --exclude "sh:$HOME/projects/**/.vscode/ipch" \
    --exclude "sh:$HOME/projects/**/node_modules" \
    --exclude "sh:$HOME/projects/**/*.so" \
    --exclude "sh:$HOME/projects/AUR/*/*.tar" \
    --exclude "sh:$HOME/projects/AUR/*/*.tar.gz" \
    --exclude "sh:$HOME/projects/AUR/*/*.tar.xz" \
    --exclude "sh:$HOME/projects/AUR/*/*.txz" \
    --exclude "sh:$HOME/projects/AUR/*/*.tar.bz2" \
    --exclude "sh:$HOME/projects/AUR/*/*.tar.zst" \
    --exclude "sh:$HOME/projects/AUR/*/*.zip" \
    --exclude "sh:$HOME/projects/AUR/*/*.AppImage" \
    --exclude "sh:$HOME/projects/AUR/*/*/*" \
    --exclude "sh:$HOME/projects/AUR/*/pkg" \
    --exclude "sh:$HOME/projects/AUR/*/src" \
    --exclude "sh:$HOME/projects/Courses/**/*.pdf" \
    --exclude "sh:$HOME/projects/Courses/**/*.npz" \
    --exclude "sh:$HOME/**/__pycache__" \
    --exclude "$HOME/projects/blog/public" \
    "::{now:%Y-%m-%d_%H-%M-%S}" \
    ~/.config \
    ~/.local/share/cargo/config.toml \
    ~/.local/share/fcitx5 \
    ~/.local/share/keyrings \
    ~/.local/share/gnupg \
    ~/.ssh \
    ~/scripts \
    ~/Pictures \
    ~/projects \
    ~/Documents \
    ~/.zshenv

# warn for abnormal delta size
last_backup_info=$(borg info --last 1 | awk '/This archive:/{print}')
last_size=$(echo "$last_backup_info" | awk '{print $7}')
last_unit=$(echo "$last_backup_info" | awk '{print $8}')

# anything other than "kB", including "MB", "GB", or possibly "B" (I dont't know the complete list of uints in borg backup)
if [[ $last_unit != "kB" ]]; then
    # delta smaller than 2 MB is fine
    if ! [[ $last_unit == "MB" && $(echo "$last_size" "2.0" | awk '{if ($1 <= $2) print 1;}') -eq 1 ]]; then
        echo "Abnormal last backup size: $last_size $last_unit"
        notify-send -u critical "Abnormal last backup size: $last_size $last_unit"
        exit 2
    fi
fi

borg prune -v --list --keep-within=10d --keep-daily=30 --keep-weekly=4 --keep-monthly=4 --save-space

borg compact
