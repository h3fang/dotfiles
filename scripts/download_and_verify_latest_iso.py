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


url = get_mirror_url() + "iso/latest"
file = "archlinux-x86_64.iso"

for f in [file, file + ".sig"]:
    check_call(f"curl -Lo $HOME/Downloads/{f} {url}/{f}", shell=True)

check_call(f"pacman-key -v $HOME/Downloads/{file}.sig", shell=True)
