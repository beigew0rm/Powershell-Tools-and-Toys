<#===================================== Beigeworm's system sounds changer =====================================

SYNOPSIS
Download any sound and set system event sounds to that file.

USAGE
1. Change WAV_FILE_URL_HERE to a hosted .wav file online OR define a local file below.
2. Run the script

NOTE
you can restore default sounds in control panel.

#>

# Download sound file
$sound = "C:Windows\Tasks\sound.wav"
$URL = iwr -Uri "WAV_FILE_URL_HERE" -OutFile $sound

# OR Define a local sound file
#$sound = "C:\Windows\media\chord.wav"

# Create an array of reg entries
$eventNames = @("WindowsUAC", "DeviceDisconnect", "DeviceConnect", "Notification.Default", "Maximize", "Minimize", "Open", "Close", "MenuPopup", "SystemNotification")

# Loop through specified entries and change the current sound
foreach ($eventName in $eventNames) {
    $KeyPath = "HKCU:\AppEvents\Schemes\Apps\.Default\$eventName\.Current"
    New-Item -Path $KeyPath -Force | Out-Null
    Set-ItemProperty -Path $KeyPath -Name "(Default)" -Value $sound -Force
}