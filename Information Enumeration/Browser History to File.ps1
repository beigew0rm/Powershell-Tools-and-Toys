$outpath = "$env:temp\history.txt"
$Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?';$Path = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
$Value = Get-Content -Path $Path | Select-String -AllMatches $regex |% {($_.Matches).Value} |Sort -Unique
$Value | ForEach-Object {$Key = $_;if ($Key -match $Search){New-Object -TypeName PSObject -Property @{User = $env:UserName;Browser = 'chrome';DataType = 'history';Data = $_}}}
$Regex2 = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?';$Pathed = "$Env:USERPROFILE\AppData\Local\Microsoft/Edge/User Data/Default/History"
$Value2 = Get-Content -Path $Pathed | Select-String -AllMatches $regex2 |% {($_.Matches).Value} |Sort -Unique
$Value2 | ForEach-Object {$Key = $_;if ($Key -match $Search){New-Object -TypeName PSObject -Property @{User = $env:UserName;Browser = 'chrome';DataType = 'history';Data = $_}}}

"Browser History    `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII
"Google Chrome `n" | Out-File -FilePath $outpath -Encoding ASCII -Append
($Value| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append
"Microsoft Edge `n" | Out-File -FilePath $outpath -Encoding ASCII -Append
($Value2| Out-String) | Out-File -FilePath $outpath -Encoding ASCII -Append

Write-Output "File Saved To > $env:temp/history.txt"
