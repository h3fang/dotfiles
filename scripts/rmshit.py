#!/usr/bin/python3

# From https://github.com/lahwaacz/Scripts/blob/master/rmshit.py

import os
import sys
import shutil
import glob

shittyfiles = [
    '~/.recently-used',
    '~/.local/share/recently-used.xbel*',
    '~/.local/share/gegl-*',
    '~/.thumbnails',
    '~/.cache/thumbnails',
    '~/.cache/chromium',
    '~/.gconfd',
    '~/.gconf',
    '~/.gstreamer-*',
    '~/.pulse',
    '~/.config/mpv/watch_later',
    '~/.parallel',
    '~/.dbus',
    '~/.nv/',
    '~/.npm/',
    '~/.java/',
    '~/.oracle_jre_usage/'
]


def yesno(question, default="n"):
    """ Asks the user for YES or NO, always case insensitive.
        Returns True for YES and False for NO.
    """
    prompt = "%s (y/[n]) " % question

    ans = input(prompt).strip().lower()

    if not ans:
        ans = default

    if ans == "y":
        return True
    return False


def rmshit():
    print("Found shittyfiles:")
    found = []
    for f in shittyfiles:
        absf = os.path.expanduser(f)
        for fl in glob.glob(absf):
            found.append(fl)
            print("    %s" % fl)

    if len(found) == 0:
        print("No shitty files found :)")
        return

    if yesno("Remove all?", default="n"):
        for f in found:
            if os.path.isfile(f):
                os.remove(f)
            else:
                shutil.rmtree(f)
        print("All cleaned")
    else:
        print("No file removed")


if __name__ == '__main__':
    rmshit()
