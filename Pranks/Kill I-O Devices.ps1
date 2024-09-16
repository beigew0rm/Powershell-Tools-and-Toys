<#
====================== Disable Mouse and Keyboard =========================

SYNOPNIS
kills all mouse and keyboard input for a few seconds.

#>

$WaitTime = 10 # how long to disable I/O (in seconds)

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
Exit
}

$PNPMice = Get-WmiObject Win32_USBControllerDevice | %{[wmi]$_.dependent} | ?{$_.pnpclass -eq 'Mouse'}
$PNPMice.Disable()

$PNPKeyboard = Get-WmiObject Win32_USBControllerDevice | %{[wmi]$_.dependent} | ?{$_.pnpclass -eq 'Keyboard'}
$PNPKeyboard.Disable()

Sleep $WaitTime

$PNPMice.Enable()
$PNPKeyboard.Enable()
