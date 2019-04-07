#!/bin/bash

# delete git commands
sed -Ei '/^(git|dot) co -m /d' ~/.bash_history
sed -Ei '/^(git|dot) (add||branch|br|st|di)/d' ~/.bash_history

# delete vscode python debugging commands
sed -Ei '/PYTHONIOENCODING=UTF-8/d' ~/.bash_history

# delete pacman commands
sed -Ei '/^(sudo )?(pacman|yay|aurman|pikaur|pacaur) /d' ~/.bash_history

# delete cd, rm, man, ls commands
sed -Ei '/^cd /d' ~/.bash_history
sed -Ei '/^(sudo )?rm /d' ~/.bash_history
sed -Ei '/^man /d' ~/.bash_history
sed -Ei '/^ls /d' ~/.bash_history

# delete vim commands
sed -Ei '/^(sudo )?vim /d' ~/.bash_history
