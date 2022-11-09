#!/usr/bin/python3

import argparse
from pathlib import Path
from subprocess import run


def walk_dir(root, cmd: str):
    last = None
    for p in sorted(Path(root).rglob("Cargo.toml")):
        if not p.is_file():
            continue
        if last and p.is_relative_to(last):
            continue
        last = p.parent
        print(last)
        if cmd == "update" or cmd == "clean" or cmd == "check":
            run(["cargo", cmd], cwd=last)
        elif cmd == "outdated":
            run(["cargo", "outdated", "-R"], cwd=last)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "command",
        nargs="?",
        choices=["list", "update", "outdated", "clean", "check"],
        default="list",
    )
    parser.add_argument(
        "-r",
        "--root",
        default=str(Path().home() / "projects"),
        help="root directory (default: ~/projects)",
    )
    args = parser.parse_args()
    walk_dir(args.root, args.command)


if __name__ == "__main__":
    main()
