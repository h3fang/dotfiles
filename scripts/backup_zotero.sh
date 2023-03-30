#!/bin/bash
# requires borg, libsecret, libnotify

set -eEuo pipefail
function error_exit {
    s=$?
    msg="$0: Error on line $(caller)"
    echo "$msg"
    notify-send "Backup" "$msg"
    exit $s
}
trap error_exit ERR

export BORG_REPO="/backup/$USER/zotero"
export BORG_PASSCOMMAND="secret-tool lookup borgrepo default"

if pgrep zotero-bin ; then
    echo "Zotero is still running."
    notify-send -u critical "Backup" "Zotero is still running."
    exit 1
fi

if [[ ! -d $BORG_REPO ]]; then
    echo "Repo $BORG_REPO doesn't exist."
    notify-send -u critical "Backup" "Repo $BORG_REPO doesn't exist."
    exit 2
fi

borg create --compression auto,zstd,16 --stats --list --filter=AME \
    --exclude "Zotero/pipes" \
    --exclude "Zotero/temp" \
    --exclude "Zotero/*.bak" \
    "::{now:%Y-%m-%d_%H-%M-%S}" \
    Zotero

borg prune -v --list --keep-within=3d --keep-daily=10 --keep-weekly=3 --keep-monthly=3 --save-space

borg compact
