<#================= ANTI AFK TOOL =======================

SYNOPSIS
Press random movement keys every second.

USAGE
1. Run Script.
2. Focus desired program (bring to top) to send keys to it

#>


Add-Type -AssemblyName System.Windows.Forms
while ($true) {
    $key = @('w','a','s','d');
    $randomKey = (Get-Random -InputObject $key -Count 1)
    [System.Windows.Forms.SendKeys]::SendWait($randomKey)
    [System.Windows.Forms.SendKeys]::SendWait($randomKey)
    sleep 1
}