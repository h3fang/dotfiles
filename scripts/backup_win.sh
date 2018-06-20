# no space after comma
# no slash after source directory
rsync -ahv --delete --ignore-errors --delete-excluded --exclude={"\$RECYCLE.BIN","System Volume Information"} /run/media/enigma/Data /run/media/enigma/stash/backup/win_Data/
rsync -ahv --delete --ignore-errors --delete-excluded /run/media/enigma/Windows/Users/hfeni/Downloads /run/media/enigma/stash/backup/win_Data/
rsync -ahv --delete --ignore-errors --delete-excluded /run/media/enigma/Windows/Users/hfeni/Pictures /run/media/enigma/stash/backup/win_Data/
rsync -ahv --delete --ignore-errors --delete-excluded /run/media/enigma/Windows/Users/hfeni/Documents/WeChat\ Files /run/media/enigma/stash/backup/win_Data/

