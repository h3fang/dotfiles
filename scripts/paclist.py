#!/usr/bin/python3

import subprocess

explicit_pkgs = subprocess.check_output("pacman -Qqe", shell=True, text=True).split("\n")
installed = {}
signature = "[ALPM] installed "
with open("/var/log/pacman.log", "rt") as f:
    for ln in reversed(list(f)):
        if signature in ln:
            tokens = ln.replace(signature, "").replace("\n", "").split(" ")
            if tokens[2] in installed:
                continue
            else:
                installed[tokens[2]] = tokens

output = []
for e in explicit_pkgs:
    if e:
        output.append(" ".join(installed[e]))

for ln in sorted(output):
    print(ln)
