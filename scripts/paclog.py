#!/usr/bin/python3
# A command line tool to filter pacman log.


import re
import math
import argparse
from subprocess import check_output, run


GREEN = '\033[92m'
ENDC = '\033[0m'


def filter_log(log_lines, keyword, max_entries):
    output = []
    signature = re.compile(fr"\b{keyword}\s+(\S+)\s+\([^)]+\)")
    for ln in log_lines[::-1]:
        m = signature.search(ln)
        if m is not None:
            output.append(ln.replace(m.group(1), GREEN + m.group(1) + ENDC))
            if len(output) >= max_entries:
                break

    return "\n".join(output[::-1])


def explicitly_installed(log_lines, max_entries):
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
                    if len(output) >= max_entries:
                        break

    return "\n".join(output[::-1])


def parse_args():
    parser = argparse.ArgumentParser(description='A tool to filter pacman log.')
    parser.add_argument(
        "filter",
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
        help="filter to apply, default %(default)s",
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
    ft = args.filter
    max_entries = args.n
    log_file = "/var/log/pacman.log"
    if ft == "a" or ft == "all":
        candidates = ["vim", "nvim", "bat", "cat"]
        for program in candidates:
            try:
                run([program, log_file])
                return
            except OSError:
                continue
        print(f"Non of {candidates} found to open the log file.")
        exit(1)
    with open(log_file, "rt") as f:
        log_lines = f.read().splitlines()
    if ft == "e" or ft == "explicitly":
        print(explicitly_installed(log_lines, max_entries))
    elif ft == "u" or ft == "upgraded":
        print(filter_log(log_lines, "upgraded", max_entries))
    elif ft == "i" or ft == "installed":
        print(filter_log(log_lines, "installed", max_entries))
    elif ft == "r" or ft == "removed" or ft == "uninstalled":
        print(filter_log(log_lines, "removed", max_entries))


if __name__ == "__main__":
    main()
