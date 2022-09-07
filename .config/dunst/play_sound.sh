#!/bin/sh
if [ "$DUNST_STACK_TAG" != "brightness" ]; then
    paplay ~/.config/dunst/notification_sound.ogg &
fi
