#!/bin/bash

ADB=adb

echo restart abd as root ...
$ADB root
$ADB disable-verity
$ADB reboot
@ping -n 30 127.1>nul
$ADB root
$ADB wait-for-device
$ADB remount

echo removing pkgs ...
# $ADB shell rm -r /system/app/BugReport
$ADB shell rm -r /system/app/Email
# $ADB shell rm -r /system/app/Galaxy4
$ADB shell rm -r /system/app/GameCenter
# $ADB shell rm -r /system/app/HoloSpiralWallpaper
$ADB shell rm -r /system/app/MiuiVideo
# $ADB shell rm -r /system/app/Mipay
# $ADB shell rm -r /system/app/MiLinkService
# $ADB shell rm -r /system/app/PaymentService
# $ADB shell rm -r /system/app/PhaseBeam
$ADB shell rm -r /system/app/SystemAdSolution
# $ADB shell rm -r /system/app/XiaomiVip
# $ADB shell rm -r /system/app/XMPass
# $ADB shell rm -r /system/app/Metok
# $ADB shell rm -r /system/app/Stk
# $ADB shell rm -r /system/app/VoiceAssist
$ADB shell rm -r /system/app/SogouInput
# $ADB shell rm -r /system/app/CloudService
# $ADB shell rm -r /system/app/XiaomiAccount
# $ADB shell rm -r /system/app/XiaomiServiceFramework

$ADB shell rm -r /system/priv-app/Browser
# $ADB shell rm -r /system/priv-app/MiDrop
# $ADB shell rm -r /system/priv-app/Mipub
$ADB shell rm -r /system/priv-app/MiGameCenterSDKService
# $ADB shell rm -r /system/priv-app/MiuiVoip
# $ADB shell rm -r /system/priv-app/Music
# $ADB shell rm -r /system/priv-app/CloudBackup

# editing hosts
# $ADB shell echo "52.84.246.72 d3c33hcgiwev3.cloudfront.net" >> /etc/hosts

echo press any key to reboot ...
pause

# failed to boot with this
#$ADB enable-verity
$ADB reboot
