[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/nopantsfriday/restart_steam_client/blob/master/LICENSE)
# About
After starting my computer I sometimes experience a bug of the steam client, rendering it having no GUI. Tired of manually killing the steam process in the task manager, I wrote a simple PowerShell script to restart steam.

# Description
 The script searches for the running process ```steam.exe```, sends a shutdown command ```steam.exe -shutdown``` and restarts steam by using the steam protocol handler ```steam:```.
# Installation and usage

1. Download [restart-steam.ps1](https://github.com/nopantsfriday/restart_steam_client/blob/main/restart-steam.ps1)

2. Right click ```Run with PowerShell```