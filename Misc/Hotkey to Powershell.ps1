<#
====================== Hotkey to Powershell Action =========================

SYNOPNIS
Map any key (default is HOME) to run some powershell script.

USAGE
1.Edit script and run.

#>

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

$VK_HOME = 0x24

while ($true) {
    $keyState = [Keyboard]::GetAsyncKeyState($VK_HOME)

    if ($keyState -band 0x8000) {


        # Perform your desired action here
        Write-Host "Home key pressed!"


    }

    Start-Sleep -Milliseconds 100
}
