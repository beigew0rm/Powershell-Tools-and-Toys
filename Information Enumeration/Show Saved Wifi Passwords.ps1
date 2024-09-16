$ps=netsh wlan show profiles|Select-String "All User Profile\s+:\s+(\S+)"|ForEach-Object {$_.Matches.Groups[1].Value}
foreach($p in $ps){$o = netsh wlan show profile name="$p" key=clear|Select-String "Key Content\s+:\s+(.+)"
if($o){$pw = $o.Matches.Groups[1].Value;Write-Output "SSID: $p";Write-Output "Password: $pw`n"}}
