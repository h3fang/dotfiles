#!/bin/bash

# delete git commands
sed -Ei '/^(git|dot) co -m /d' ~/.bash_history
sed -Ei '/^(git|dot) (add|status|diff|branch|br|st|di)\b/d' ~/.bash_history

# delete vscode python debugging commands
sed -Ei '/PYTHONIOENCODING=UTF-8/d' ~/.bash_history

# delete pacman commands
#sed -Ei '/^(sudo )?(pacman|yay|aurman|pikaur|pacaur) /d' ~/.bash_history

# delete cd, rm, man, ls, etc.
sed -Ei '/^(sudo )?(cd|rm|ls|cat|man|which|[pfe]?grep)( |$)/d' ~/.bash_history

# delete vim commands
#sed -Ei '/^(sudo )?vim /d' ~/.bash_history
