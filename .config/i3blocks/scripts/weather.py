#!/usr/bin/python3

import os,requests

r = requests.get("https://wttr.in/?format=%C+%t&lang=zh")

if r.status_code != 200:
    a = os.getenv("OWM_AID")
    if a is None:
        exit(1)
    r = requests.get(f'https://api.openweathermap.org/data/2.5/weather?q=Hong%20Kong&units=metric&lang=zh_cn&appid={a}')
    if r.status_code != 200:
        exit(2)

    d = r.json()
    description = d['weather'][0]['description']
    temperature = d['main']['temp']
    print(f"{description} {temperature:.0f}℃")
else:
    print(r.text.rstrip().replace("+", ""))
