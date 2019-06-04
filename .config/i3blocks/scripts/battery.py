#!/usr/bin/python3
import subprocess as sp
import os,re
from pathlib import Path

bat_num = int(os.getenv("BAT_NUMBER", "0"))
bat_info = sp.run(f"acpi -b | grep 'Battery {bat_num}'", shell=True, capture_output=True).stdout.decode('utf-8')
status, percent, time = re.match(f"Battery {bat_num}: " + r"(\w+), (\d+)%,? ?(\d+\:\d+)?\:?(\d+)?", bat_info).groups()[:3]
percent = int(percent)

if status == "Discharging":
    full_text = "" + f"{percent}% ({time})"
elif status == "Charging":
    full_text = " " + f"{percent}% ({time})"
else:
    full_text = "" + f"{percent}%"

print(full_text)
print(full_text)

critical = Path("/tmp/h3f_battery_critical")
low = Path("/tmp/h3f_battery_low")

if status == "Discharging":
    if percent < 20:
        if not critical.exists():
            critical.touch()
            sp.run(f"notify-send -u critical 'Low battery' 'Battery running critically low at {percent}%'", shell=True)
        print("#FF0000")

        if percent < 10:
            exit(33)
    else:
        if critical.exists():
            critical.unlink()
        if percent < 40:
            if not low.exists():
                low.touch()
                sp.run(f"notify-send -u critical 'Low battery' 'Battery running critically low at {percent}%'", shell=True)
            print("#FFAE00")
        else:
            if low.exists():
                low.unlink()
            if percent < 60:
                print("#FFF600")
            elif percent < 85:
                print("#A8FF00")
else:
    if critical.exists():
        critical.unlink()
    if low.exists():
        low.unlink()
