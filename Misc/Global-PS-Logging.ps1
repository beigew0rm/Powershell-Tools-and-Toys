<# ===================== Beigeworm Global Powershell Transcription =====================

SYNOPSIS
Log all powershell input and output to a text file in the documents folder.

USAGE
1. Run once to enable logging
2. Check transcript files in 'WindowsPowerShell' in Documents folder
3. Run once more to remove logging

NOTES
Admin Permissions may be required. (for setting execution policies and registry keys)

#>

$outputMessage = 1 # Set to 0 for NO popup message or 1 for popup

[Console]::BackgroundColor = "Black"
[Console]::SetWindowSize(60, 20)
Clear-Host
[Console]::Title = "Powershell Logging"

Test-Path $Profile
$directory = Join-Path ([Environment]::GetFolderPath("MyDocuments")) WindowsPowerShell
$ps1Files = Get-ChildItem -Path $directory -Filter *.ps1

function CreateRegKeys {
    param ([string]$KeyPath)

    if (-not (Test-Path $KeyPath)) {
        Write-Host "Creating registry keys" -ForegroundColor Green
        New-Item -Path $KeyPath -Force | Out-Null
    }
}

Function RestartScript{
    if($PSCommandPath.Length -gt 0){
        Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    }
    else{
        Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -C irm https://raw.githubusercontent.com/beigeworm/Powershell-Tools-and-Toys/main/Misc/Global-PS-Logging.ps1 | iex") -Verb RunAs
    }

    exit
}

if ($ps1Files.Count -gt 0) {
    Write-Host "Removing Powershell logging" -ForegroundColor Green
    Get-ChildItem -Path $directory -Filter *.ps1 | Remove-Item -Force
    sleep 3
    If (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
        Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableModuleLogging" -Value 0
        Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableScriptBlockLogging" -Value 0
    }
    exit
}

Write-Host "Checking user permissions.." -ForegroundColor DarkGray

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "Checking Execution Policy.." -ForegroundColor DarkGray
    $policy = Get-ExecutionPolicy
    $Keytest = "HKLM:\Software\Policies\Microsoft\Windows\PowerShell"
    if (($policy -notlike 'Unrestricted') -or ($policy -notlike 'RemoteSigned') -or ($policy -notlike 'Bypass') -or (-not (Test-Path $Keytest))){
        if (($policy -notlike 'Unrestricted') -or ($policy -notlike 'RemoteSigned') -or ($policy -notlike 'Bypass')){
            Write-Host "Execution Policy is Restricted!.." -ForegroundColor Red
        }
        if (-not (Test-Path $Keytest)){
           Write-Host "Registry path doesn't exist!.." -ForegroundColor Red 
        }
        Write-Host "Restarting as Administrator.." -ForegroundColor Red 
        sleep 2
        RestartScript
    }
}
else{
    Write-Host "Ckecking log registry keys.." -ForegroundColor DarkGray
    CreateRegKeys -KeyPath "HKLM:\Software\Policies\Microsoft\Windows\PowerShell"
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableModuleLogging" -Value 1
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableScriptBlockLogging" -Value 1

    Write-Host "Checking Execution Policy.." -ForegroundColor DarkGray
    $policy = Get-ExecutionPolicy
    if (($policy -ne 'Unrestricted') -or ($policy -ne 'RemoteSigned') -or ($policy -ne 'Bypass')){
        Set-ExecutionPolicy Unrestricted
        Write-Host "Set Execution Policy to Unrestricted." -ForegroundColor Green
    }
    else{
        Write-Host "Execution Policy is already Unrestricted.." -ForegroundColor Green
    }
}


if ($ps1Files.Count -eq 0) {
    Write-Host "Adding Powershell logging" -ForegroundColor Green
    New-Item -Type File $Profile -Force
    if ($outputMessage -ne 0){
        msg.exe * "LOG FILES: $directory"
    }
    else{
        Write-Host "`nLOG FILES: $directory`n" -ForegroundColor Cyan
        Write-Host "Closing Script..." -ForegroundColor Red
        sleep 3
    }
}

$scriptblock = @"
`$transcriptDir = Join-Path ([Environment]::GetFolderPath("MyDocuments")) WindowsPowerShell
if (-not (Test-Path `$transcriptDir))
{
    New-Item -Type Directory `$transcriptDir
}
`$dateStamp = Get-Date -Format ((Get-culture).DateTimeFormat.SortableDateTimePattern -replace ':','.')
try 
{
    Start-Transcript "`$transcriptDir\Transcript.`$dateStamp.txt" | Out-File -FilePath "$transcriptDir\Transcripts_Logging.txt" -Append
}
catch [System.Management.Automation.PSNotSupportedException]
{
    return
} 
"@

$scriptblock | Out-File -FilePath $Profile -Force
