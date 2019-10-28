#!/usr/bin/python3

import subprocess

explicit_pkgs = subprocess.check_output("pacman -Qqe", shell=True, text=True).split("\n")
installed = {}
signature = "[ALPM] installed "
with open("/var/log/pacman.log", "rt") as f:
    for ln in reversed(list(f)):
        if signature in ln:
            tokens = ln.replace(signature, "").replace("\n", "").split(" ")
            if len(tokens) == 4:
                t_i = 2
            elif len(tokens) == 3:
                t_i = 1
            else:
                raise RuntimeError("Invalid number of tokens.")

            if tokens[t_i] in installed:
                continue
            else:
                installed[tokens[t_i]] = tokens

output = []
for e in explicit_pkgs:
    if e:
        output.append(" ".join(installed[e]))

for ln in sorted(output):
    print(ln)
