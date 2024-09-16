<#
#============================================= beigeworm's Filesystem Monitor ========================================================

SYNOPSIS
This script gathers information about any changes to any files in the "%USERPROFILE% folder".


USAGE
2. Run Script on target System
3. Check temp folder for results

#>

$outpath = "$env:temp\fileinfo.txt"

$watcher = New-Object System.IO.FileSystemWatcher -Property @{
    Path = $env:USERPROFILE + '\Desktop'
}
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName -bor `
                        [System.IO.NotifyFilters]::LastWrite -bor `
                        [System.IO.NotifyFilters]::DirectoryName

$action = {
    $event = $EventArgs
    $path = $event.FullPath
    $changeType = $event.ChangeType
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] File $changeType : $path"
    "[$timestamp] File $changeType > $path" | Out-File -FilePath $outpath -Encoding ASCII -Append
}

Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action

$watcher.EnableRaisingEvents = $true

while ($true) {
    Start-Sleep -Milliseconds 500
}

Unregister-Event -InputObject $watcher -EventName Created -Action $action
Unregister-Event -InputObject $watcher -EventName Deleted -Action $action
Unregister-Event -InputObject $watcher -EventName Changed -Action $action
