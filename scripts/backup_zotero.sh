#!/bin/bash
# requires borg, libsecret, libnotify, rclone

set -eEuo pipefail
error_exit() {
    s=$?
    echo "$0: Error on line $LINENO"
    notify-send "$0: Error on line $LINENO"
    exit $s
}
trap error_exit ERR

export BORG_REPO=$HOME/.local/share/backups/zotero
export BORG_PASSCOMMAND="secret-tool lookup borgrepo default"
REMOTE_DIR=Zotero
RCLONE_REMOTES=('googledrive' 'onedrive' 'tera')

if pgrep zotero-bin ; then
    echo "Zotero is still running."
    notify-send -u critical "Backup zotero" "Zotero is still running."
    exit 1
fi

if [[ ! -d $BORG_REPO ]]; then
    echo "Repo $BORG_REPO doesn't exist."
    notify-send -u critical "Backup zotero" "Repo $BORG_REPO doesn't exist."
    exit 2
fi

borg create --compression auto,zstd,16 --stats --list --filter=AME \
    --exclude "Zotero/pipes" \
    --exclude "Zotero/temp" \
    --exclude "Zotero/*.bak" \
    "::{now:%Y-%m-%d_%H-%M-%S}" \
    Zotero

borg prune -v --list --keep-within=3d --keep-daily=10 --keep-weekly=3 --keep-monthly=3 --save-space

for remote in "${RCLONE_REMOTES[@]}"; do
    echo "syncing with ${remote} ..."
    rclone --drive-use-trash=false sync "$BORG_REPO" "${remote}:${REMOTE_DIR}" --timeout=30s --fast-list --transfers=10
done

