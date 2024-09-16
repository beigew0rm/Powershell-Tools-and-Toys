<#

========================= Mon's Clipboard History ===========================

This Script creates a powershell script in the temp directory and then monitors the clipboard for changes and the saves
those changes to a text file in the temp directory named "Clipboard_History.txt"


USAGE
1. Run this script in powershell
2. open the results file with this command in the run prompt >  %Temp%/Clipboard_History.txt

#>

$clipmon = @'

$filePath = "$env:temp\Clipboard_History.txt"
$previousClipboardContent = ""
$previousAppendedClipboardContent = ""
while ($true) {
    $clipboard = Get-Clipboard
    if ($clipboard -ne $previousClipboardContent) {
        if ($clipboard -ne $previousAppendedClipboardContent) {
            $clipboard | Out-File -FilePath $filePath -Append

            $previousAppendedClipboardContent = $clipboard
        }

        $previousClipboardContent = $clipboard
    }
Start-Sleep -Seconds 10
}

'@

$clipmon | Out-File -FilePath "$env:temp\Clipboard_History.ps1" -Force

Start-Sleep 1

Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\Clipboard_History.ps1`"")
