#!/usr/bin/python3

from pathlib import Path
from subprocess import check_call
import re


def get_mirror_url() -> str:
    with open("/etc/pacman.d/mirrorlist") as f:
        r = re.compile(r"^\s*Server\s*=\s*(.*)\$repo/os/\$arch\s*$")
        for line in f:
            m = r.match(line)
            if m is not None:
                return m.group(1)
    raise RuntimeError("/etc/pacman.d/mirrorlist doesn't contain a valid mirror")


dir = Path().home() / "Downloads"
url = get_mirror_url() + "iso/latest"
file = "archlinux-x86_64.iso"

for f in [file, file + ".sig"]:
    check_call(["curl", "-Lo", dir / f, f"{url}/{f}"])

check_call(["pacman-key", "-v", dir / f"{file}.sig"])
