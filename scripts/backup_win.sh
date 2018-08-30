# no space after comma
# no slash after source directory
rsync -ahv --delete --ignore-errors --delete-excluded --exclude={"\$RECYCLE.BIN","System Volume Information"} /run/media/enigma/Data /media/stash/backup/win_Data/
rsync -ahv --delete --ignore-errors --delete-excluded /run/media/enigma/Windows/Users/hfeni/Downloads /media/stash/backup/win_Data/
rsync -ahv --delete --ignore-errors --delete-excluded /run/media/enigma/Windows/Users/hfeni/Pictures /media/stash/backup/win_Data/

