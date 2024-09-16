<#=========================== Terminal Shortcut Creator =============================

SYNOPSIS
This script asks the user to specify a program or executable,
Then create a custom command to start it from a terminal or run prompt.
Eg. in a terminal or run prompt type 'discord' to start discord from the console.

LIMITATIONS
1. Admin required to set path variables and creating a symbolic link for the custom name/command. 
2. some programs like discord store the executable in a folder named with a version number
   therefore the custom command will likely not work after updates. (you can fix this by running this script again..)

USAGE
1. Run the script.
2. Follow instructions to create your terminal shortcut.

#>


[Console]::SetWindowSize(80, 25)
[Console]::Title = " Terminal Shortcut Creator"
[Console]::CursorVisible = $false
[Console]::BackgroundColor = "Black"
cls

Write-Host "select a program or executable and create a 
custom command to start it from a terminal or run prompt.`n" -ForegroundColor Gray
sleep 2

Write-Host "Checking User Permissions.." -ForegroundColor DarkGray
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "Admin privileges needed for this script..." -ForegroundColor Red
    Write-Host "This script will self elevate to run as an Administrator and continue." -ForegroundColor DarkGray
    Write-Host "Sending User Prompt."  -ForegroundColor Green
    sleep 1
    Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    exit
}
else{
    Write-Host "This script is running as Admin!`n"  -ForegroundColor Green
}

Write-Host "Select a program from the browser..`n" -ForegroundColor Yellow
sleep 1

Add-Type -AssemblyName System.Windows.Forms
$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.InitialDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$openFileDialog.Filter = "Executable Files (*.exe)|*.exe|All Files (*.*)|*.*"
$openFileDialog.Multiselect = $false
$result = $openFileDialog.ShowDialog()
cls

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $exePath = $openFileDialog.FileName
} 
else{
    Write-Host "No executable selected. Enter path manually." -ForegroundColor Yellow
    if ($exePath.Length -eq 0) {
        $exePath = Read-Host "Enter the full path of the executable"
        $exePath = $exePath.Trim('"')
        Write-Host "Path set successfully" -ForegroundColor Red
    }
    else{
        Write-Host "Error: The provided executable path does not exist." -ForegroundColor Red
        $exePath = $null
    }
}

if ($exePath.Length -eq 0) {
    $exePath = Read-Host "Enter the full path of the executable"
    $exePath = $exePath.Trim('"')
    Write-Host "Error: The provided executable path does not exist." -ForegroundColor Red
    exit
}

$exeFolderPath = Split-Path -Path $exePath -Parent

$userEnvKey = $null
while ($userEnvKey.Length -eq 0){

    cls
    $SysOrUser = Read-Host "Store this path variable in 'System' or 'User' variables
    
1. User
2. System
    
Choose an option "

    
    if ($SysOrUser.Length -ne 0){
        if ($SysOrUser -eq 1){
            $userEnvKey = "Registry::HKEY_CURRENT_USER\Environment"
            Write-Host "Using USER environment variables" -ForegroundColor DarkGray
        }
        if ($SysOrUser -eq 2){
            $userEnvKey = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
            Write-Host "Using SYSTEM environment variables" -ForegroundColor DarkGray
        }
    }
    else{
        Write-Host "Error: Please choose an option" -ForegroundColor Red
        pause
    }

    sleep 1
}

$currentEnvPath = (Get-ItemProperty -Path $userEnvKey -Name "Path").Path

if (-not ($currentEnvPath -split ";" | Select-String -SimpleMatch $exeFolderPath)) {
    $newEnvPath = "$currentEnvPath;$exeFolderPath\"
    Set-ItemProperty -Path $userEnvKey -Name "Path" -Value $newEnvPath
}

$linkName = Read-Host "Enter your custom name to start the program "
try{
    New-Item -ItemType SymbolicLink -Path $exeFolderPath -Name $linkName -Value "$exePath"
    Write-Host "Symlink created successfully!" -ForegroundColor Green
}
catch{
    Write-Host "Error: Symlink not created. Admin required.." -ForegroundColor Red
}

cls
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User")
Write-Host "System's environment variables reloaded successfully!`n" -ForegroundColor Green

Write-Host "OPERATION COMPLETED!" -ForegroundColor Green
pause
