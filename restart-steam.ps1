<#
.SYNOPSIS
    Restarting Valve's steam client.

.DESCRIPTION
     After starting my computer I sometimes experience a bug of the steam client, rendering it having no GUI. Tired of manually killing the steam process in the task manager, I wrote a simple script to restart steam.
     The script will search a running process ```steam.exe```, send a shutdown command ```steam.exe -shutdown``` and restart steam by using the steam protocol handler ```steam:```.

.PARAMETER Param1
    No parameters yet.

.EXAMPLE
    Example syntax for running the script or function
    PS C:\> restart-steam.ps1
.LINK
    https://github.com/nopantsfriday/restart_steam_client

.NOTES
    Filename: restart-steam.ps1
    Author: https://github.com/nopantsfriday
    Modified date: 2022-03-19
    Version 1.0 - Initial release without any try catch and steam procotol check as it works flawlessly on the developers machine.
    Versiion 1.0.1 - Check if Steam protocol handler is registered.
#>

$steam_running = Get-Process -name steam -ErrorAction SilentlyContinue
if ($steam_running) {

    $steam = ( get-process -name steam).path 
    Write-Host "Found Steam client: " -NoNewline; Write-Host $steam -BackgroundColor Black -ForegroundColor Cyan
    &$steam -shutdown
    Write-Host "Sending shutdown command: " -NoNewline; Write-Host $steam "-shutdown" -BackgroundColor Black -ForegroundColor Cyan
    Write-Host "Starting Steam in 5 seconds." -ForegroundColor DarkYellow
    Start-Sleep -s 5
    Write-Host "Starting Steam." -ForegroundColor Green
    &$steam
    
}
if (!$steam_running) {
    if ((Test-Path -Path "registry::HKEY_CLASSES_ROOT\steam\Shell\Open\Command")) {
        Write-Host "Steam not running. Starting Steam." -ForegroundColor Green
        Start-Process steam:
    }
    else {
        Write-Host "Steam is not running and the Steam protocol handler could not be found. Pleas start Steam manually." -ForegroundColor Red
        Start-Sleep -s 5
    }
}