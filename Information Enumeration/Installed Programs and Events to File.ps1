<#
============================ Mon's Programs and Events Info Gatherer =============================

SYNOPSIS
This script Looks through Event logs and installed program information and collates
everything into an output file in the Temp directory.
(Admin privileges will be needed for detail infomation in event logs)


USAGE
1. Run script
2. Open output file to see gathered information.

#>


$date = Get-Date -Format "yyyy-MM-dd-hh-mm-ss"
$outputPath = "$env:temp\Osint-$date.txt"

New-Item -ItemType File -Path $outputPath

$installed = Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version, Vendor
$hotfixes = Get-WmiObject -Class Win32_QuickFixEngineering | Select-Object -Property HotFixID, Description, InstalledOn
$removed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object -Property DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object {$_.DisplayName -ne $null}

$installed | Format-Table -AutoSize | Out-File -FilePath $outputPath 
$hotfixes | Format-Table -AutoSize | Out-File -FilePath $outputPath -Append
$removed | Format-Table -AutoSize | Out-File -FilePath $outputPath -Append

$userActivity = Get-EventLog -LogName Security -EntryType SuccessAudit | Where-Object {$_.EventID -eq 4624 -or $_.EventID -eq 4634}
$userActivity | Out-File -FilePath $outputPath -Append
$hardwareInfo = Get-EventLog -LogName System | Where-Object {$_.EventID -eq 12 -or $_.EventID -eq 13}
$hardwareInfo | Out-File -FilePath $outputPath -Append
