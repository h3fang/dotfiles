#!/usr/bin/python3
# A command line tool to filter pacman log.


import re
import math
import argparse
from subprocess import check_output, run


GREEN = '\033[92m'
ENDC = '\033[0m'


def filter_log(log_lines, keyword, maximum_output_entries):
    output = []
    signature = re.compile(fr"\b{keyword}\s+(\S+)\s+\([^)]+\)")
    for ln in log_lines[::-1]:
        m = signature.search(ln)
        if m is not None:
            output.append(ln.replace(m.group(1), GREEN + m.group(1) + ENDC))
            if len(output) >= maximum_output_entries:
                break

    return "\n".join(output[::-1])


def explicitly_installed(log_lines, maximum_output_entries):
    explicit_pkgs = set(check_output("pacman -Qqe", shell=True, text=True).splitlines())
    installed = set()
    output = []
    signature = re.compile(r"\binstalled\s+(\S+)\s+\([^)]+\)")
    for ln in log_lines[::-1]:
        m = signature.search(ln)
        if m is not None:
            pkg = m.group(1)
            if pkg in explicit_pkgs:
                if pkg in installed:
                    continue
                else:
                    installed.add(pkg)
                    output.append(ln.replace(m.group(1), GREEN + m.group(1) + ENDC))
                    if len(output) >= maximum_output_entries:
                        break

    return "\n".join(output[::-1])


def parse_args():
    parser = argparse.ArgumentParser(description='A tool to filter pacman log.')
    parser.add_argument(
        "command",
        default="a",
        const="all",
        nargs="?",
        choices=[
            "u", "upgraded",
            "i", "installed",
            "e", "explicitly",
            "a", "all",
            "r", "removed", "uninstalled"
        ],
        help="command to execute, default %(default)s",
    )
    parser.add_argument(
        "-n",
        type=int,
        help="maximum number of entries to list, default %(default)s",
        default=math.inf,
    )
    return parser.parse_args()


def main():
    args = parse_args()
    command = args.command
    maximum_output_entries = args.n
    log_file = "/var/log/pacman.log"
    if command == "a" or command == "all":
        try:
            run(["vim", log_file])
        except :
            run(["cat", log_file])
        return
    with open(log_file, "rt") as f:
        log_lines = f.read().splitlines()
    if command == "e" or command == "explicitly":
        print(explicitly_installed(log_lines, maximum_output_entries))
    elif command == "u" or command == "upgraded":
        print(filter_log(log_lines, "upgraded", maximum_output_entries))
    elif command == "i" or command == "installed":
        print(filter_log(log_lines, "installed", maximum_output_entries))
    elif command == "r" or command == "removed" or command == "uninstalled":
        print(filter_log(log_lines, "removed", maximum_output_entries))


if __name__ == "__main__":
    main()
