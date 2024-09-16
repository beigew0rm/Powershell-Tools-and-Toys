<#
============================= beigeworms system tray toolbox ===================================


SYNOPSIS
Creates an icon in the system tray with useful tools and features from  -  https://github.com/beigeworm/Powershell-Tools-and-Toys

USAGE
Runs the script and use the tray icon to control the script.


#>



# ---------------------- SETUP --------------------------
# General Setup
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  	 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 	 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') 		 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration') | out-null
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
$contextmenu = New-Object System.Windows.Forms.ContextMenuStrip

# ------------------- TRAY ELEMENTS -----------------------

# Main Tray Icon
$Systray_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Systray_Tool_Icon.Text = "============
= ---- Tools ---- =
============"
$Systray_Tool_Icon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\control.exe")
$Systray_Tool_Icon.Visible = $true
$Systray_Tool_Icon.ContextMenuStrip = $contextmenu

# IP Address Display
$iptaxt = (Inv`o`ke-`W`ebR`e`qu`e`st ifconfig.me/ip).Content.Trim()
$traytitle = $contextmenu.Items.Add("IPv4 Address: $iptaxt");
$traytitle_Picture =[System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\newdev.exe")
$traytitle.Image = $traytitle_Picture

$social = $contextmenu.Items.Add("Username Search");
$social_Picture = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\EhStorAuthn.exe")	
$social.Image = $social_Picture

$landevice = $contextmenu.Items.Add("LAN Devices");
$landevice_Picture = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\iscsicli.exe")	
$landevice.Image = $landevice_Picture

$microphone = $contextmenu.Items.Add("Microphone Mute");
$microphone_Picture = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\SndVol.exe")	
$microphone.Image = $microphone_Picture

$DCspam = $contextmenu.Items.Add("Discord Spam");
$DCspam_Picture = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\cmmon32.exe")	
$DCspam.Image = $DCspam_Picture

$httpserver = $contextmenu.Items.Add("HTTP Server");
$httpserver_Picture = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\iexpress.exe")	
$httpserver.Image = $httpserver_Picture

$decode = $contextmenu.Items.Add("Encode/Decode Base64");
$decode_Picture = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\dpapimig.exe")	
$decode.Image = $decode_Picture

# Important Functions
$Menu_Restart = $contextmenu.Items.Add("Restart");
$Menu_Restart_Picture =[System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\Dxpserver.exe")	
$Menu_Restart.Image = $Menu_Restart_Picture
 
$Menu_Exit = $contextmenu.Items.Add("Exit");
$Menu_Exit_Picture =[System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\DFDWiz.exe")
$Menu_Exit.Image = $Menu_Exit_Picture


# --------------------- FUNCTIONS ----------------------------


$Social.add_Click({

$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C irm https://raw.githubusercontent.com/beigeworm/assets/main/GUI/SocialGUI.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1010.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
Write-Output "Done."
sleep 3
Remove-Item -Path $pth -Force
})

 
$landevice.add_Click({

$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C irm https://raw.githubusercontent.com/beigeworm/assets/main/GUI/NetworkGUI.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1010.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
Write-Output "Done."
sleep 3
Remove-Item -Path $pth -Force
})


$microphone.add_Click({

$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C irm https://raw.githubusercontent.com/beigeworm/assets/main/GUI/MuteGUI.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1010.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
Write-Output "Done."
sleep 3
Remove-Item -Path $pth -Force
})

$DCspam.add_Click({

$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C irm https://raw.githubusercontent.com/beigeworm/assets/main/GUI/DiscordSpamGUI.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1010.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
Write-Output "Done."
sleep 3
Remove-Item -Path $pth -Force
})

$httpserver.add_Click({

$FolderDialog = New-Object Windows.Forms.FolderBrowserDialog

if ($FolderDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
    $SelectedFolderPath = $FolderDialog.SelectedPath
}

sleep 1
cd $SelectedFolderPath
$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C irm https://raw.githubusercontent.com/beigeworm/assets/main/Scripts/FolderVBS.ps1 | iex", 0, True
'@
$tobat | Out-File -FilePath "$SelectedFolderPath/a.vbs" -Force
sleep 1
Start-Process -FilePath "$SelectedFolderPath/a.vbs"
Write-Output "Done."
sleep 5
Remove-Item -Path "$SelectedFolderPath/a.vbs" -Force
})


$decode.add_Click({

$tobat = @'
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C irm https://raw.githubusercontent.com/beigeworm/assets/main/GUI/Base64GUI.ps1 | iex", 0, True
'@
$pth = "$env:APPDATA\Microsoft\Windows\1010.vbs"
$tobat | Out-File -FilePath $pth -Force
sleep 1
Start-Process -FilePath $pth
Write-Output "Done."
sleep 3
Remove-Item -Path $pth -Force

})

$Menu_Restart.add_Click({
 Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -W hidden -File `"{0}`"" -f $PSCommandPath)
 
 $Systray_Tool_Icon.Visible = $false
 $window.Close()
 Stop-Process $pid
 })

$Menu_Exit.add_Click({
 $Systray_Tool_Icon.Visible = $false
 $window.Close()
 Stop-Process $pid
})


# ---------------------- START TRAY TOOL ------------------------

$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)
