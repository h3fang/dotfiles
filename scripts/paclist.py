#!/usr/bin/python3

import subprocess

explicit_pkgs = subprocess.check_output("pacman -Qqe", shell=True, text=True)
installed = []
signature = "[ALPM] installed "
with open("/var/log/pacman.log", "r") as f:
    installed = [ln.replace(signature, "").replace("\n", "") for ln in f if signature in ln]

installed = installed[::-1]
output = []
for i in explicit_pkgs.split():
    for ln in installed:
        if i in ln:
            output.append(ln)
            break

for ln in sorted(output):
    print(ln)
