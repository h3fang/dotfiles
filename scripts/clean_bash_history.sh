#!/bin/bash

# delete git commands
sed -Ei '/^(git|dot) co -m /d' ~/.bash_history
sed -Ei '/^(git|dot) (add|status|diff|branch|br|st|di)\b/d' ~/.bash_history

# delete vscode python debugging commands
sed -Ei '/PYTHONIOENCODING=UTF-8/d' ~/.bash_history

# delete pacman commands
sed -Ei '/^(sudo )?(pacman|yay|aurman|pikaur|pacaur) /d' ~/.bash_history

# delete cd, rm, man, ls, etc.
sed -Ei '/^(sudo )?(cd|rm|ls|ll|exa|tree|cat|bat|man|which|[pfe]?grep|cp|mv|fd|find|pip)( |$)/d' ~/.bash_history

# curl, wget, youtube-dl
sed -Ei '/^(sudo )?(curl|wget|youtube-dl) /d' ~/.bash_history

# delete vim commands
sed -Ei '/^(sudo )?(vim|nvim) /d' ~/.bash_history

# delete cargo test subcommands
sed -Ei '/^cargo t /d' ~/.bash_history

# list top 10 commands
awk '{print $1}' ~/.bash_history | sort | uniq -c | sort -n | tail -10
