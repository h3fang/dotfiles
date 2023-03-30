#!/bin/bash
# requires rclone

set -eEuo pipefail

REMOTE_DIR="archlinux-$(cat /etc/machine-id)"
RCLONE_REMOTES=('googledrive' 'onedrive' 'tera')

for remote in "${RCLONE_REMOTES[@]}"; do
    echo "syncing backup with ${remote} ..."
    rclone --drive-use-trash=false sync /backup "${remote}:${REMOTE_DIR}" --timeout=30s --fast-list --transfers=10
done

