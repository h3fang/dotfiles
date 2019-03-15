# no space after comma
# no slash after source directory

PREFIX=/run/media/enigma

rsync -ahv --delete --ignore-errors --delete-excluded --exclude={"\$RECYCLE.BIN","System Volume Information"} $PREFIX/Data $PREFIX/stash/backup/win_Data/
rsync -ahv --delete --ignore-errors --delete-excluded $PREFIX/Windows/Users/hfeni/Downloads $PREFIX/stash/backup/win_Data/
rsync -ahv --delete --ignore-errors --delete-excluded $PREFIX/Windows/Users/hfeni/Pictures $PREFIX/stash/backup/win_Data/

