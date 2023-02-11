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
    Create date: 2022-03-18
    Modified date: 2023-02-12
    Version 1.0 - Initial release without any try catch and steam procotol check as it works flawlessly on the developers machine.
    Version 1.0.1 - Added Steam protocol check, added termination of Steam process when Steam could not be shutdown gracefully
#>

$steam_running = Get-Process -name steam -ErrorAction SilentlyContinue
if ($steam_running) {

    $steam = ( get-process -name steam).path 
    Write-Host "Found Steam client:"; Write-Host $steam -BackgroundColor Black -ForegroundColor Cyan
    Write-Host "Sending shutdown command. Waiting 10 seconds for Steam to start."; Write-Host $steam "-shutdown" -BackgroundColor Black -ForegroundColor Cyan
    &$steam -shutdown
    Start-Sleep -s 10
    if (Get-Process -Name "steam" -ErrorAction SilentlyContinue) {
        Stop-Process -Name "steam" -ErrorAction SilentlyContinue
        Write-Host "Steam could not be shutdown gracefully and was terminated." -ForegroundColor Red
    }
    &$steam
    Start-Sleep -s 1
    if ( (Get-Process -Name "steam" -ErrorAction SilentlyContinue).Count -eq 1) {
        Write-Host "Steam started successfully." -ForegroundColor Green
    }
    else {
        Write-Host "Steam could not be started. Please try to start Steam manually." -ForegroundColor Red
    }
}
if (!$steam_running) {
    Write-Host "Steam is not running. Trying to start steam." -ForegroundColor DarkRed

    $test_steam_protocol = test-Path -Path registry::HKEY_CLASSES_ROOT\steam

    if (!$test_steam_protocol) {
        write-host "Could not find Steam handler. Steam might not be properly installed." -ForegroundColor Red
    }
    else {
        Write-Host "Starting Steam"
        Start-Process steam:
    }

    Start-Sleep -s 1
    if ( (Get-Process -Name "steam" -ErrorAction SilentlyContinue).Count -eq 1) {
        Write-Host "Steam started successfully." -ForegroundColor Green
    }
    else {
        Write-Host "Steam could not be started. Please try to start Steam manually." -ForegroundColor Red
    }
}

function keypress_wait {
    param (
        [int]$seconds = 10
    )
    $loops = $seconds * 10
    Write-Host "Press any key to exit. (Window will automatically close in $seconds seconds.)" -ForegroundColor Yellow
    for ($i = 0; $i -le $loops; $i++) {
        if ([Console]::KeyAvailable) { break; }
        Start-Sleep -Milliseconds 100
    }
    if ([Console]::KeyAvailable) { return [Console]::ReadKey($true); }
    else { return $null ; }
}
keypress_wait