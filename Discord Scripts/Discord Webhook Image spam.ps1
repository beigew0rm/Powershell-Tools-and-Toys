<#
========================= Discord Webhook Spammer ============================--

SYNOPSIS
This script will spam a discord webhook with an invisible image which will clear the chat feed.

USAGE
1. Change '10' to the number of shortcuts you want created
2. Run the script.

#>



$hookurl = 'YOUR_WEBHOOK_HERE' # replace with your webhook
$n = 10                        # the number of messages sent in total.
$b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAQAAAUeCAYAAABZhJAkAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACISURBVHhe7c1LDoAgDAVAjqRoIt7/YMjPwNaVm1k0pdPXEPYj5bUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD4Bld5zApxbN7eE3FJ7GfKW92W3hItGvtQezm5yzCrfdtORh+JCktiLQDAr5DyA9jL3oe8Lgu3AAAAAElFTkSuQmCC'
$decodedFile = [System.Convert]::FromBase64String($b64)
$File = "$env:temp\bl.png"
Set-Content -Path $File -Value $decodedFile -Encoding Byte
$i = 0
while($i -lt $n) {
curl.exe -F "file1=@$file" $hookurl
$i++
}

Remove-Item -Path $file
