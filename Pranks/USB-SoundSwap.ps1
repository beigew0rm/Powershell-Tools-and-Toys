<#===================================== Beigeworm's USB device sound swapper =====================================

SYNOPSIS
Swaps the USB Device connect and disconnect sounds. 

USAGE
1. Run once to swap the sounds
2. Run the script again to restore to default sounds

#>

$Connect = "C:\Windows\media\Windows Hardware Insert.wav"
$Disconnect = "C:\Windows\media\Windows Hardware Remove.wav"

$Path1 = "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current"
$Path2 = "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current"

$Which = Get-ItemProperty  -Path $Path1 -Name "(Default)"
if ($Which.'(default)' -eq $Connect){
Set-ItemProperty -Path $Path1 -Name "(Default)" -Value $Disconnect -Force
Set-ItemProperty -Path $Path2 -Name "(Default)" -Value $Connect -Force
Write-Host "Set to Default Sounds"
}
else{
Set-ItemProperty -Path $Path1 -Name "(Default)" -Value $Connect -Force
Set-ItemProperty -Path $Path2 -Name "(Default)" -Value $Disconnect -Force
Write-Host "Swapped USB Connect/Disconnect Sounds"
}