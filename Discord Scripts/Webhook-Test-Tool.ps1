<#=====================================  WEBHOOK TEST TOOL =======================================================

SYNOPSIS
Test a webhook with this tool to confirm it is live.
Can test Webhooks converted to a short URL (tested with https://t.ly)

USAGE
1. Add your webhook to the script below.
2. Choose 'Simple' OR 'Full' Module.
3. Run the script
4. Check Discord for results.

#>

# Define the Webhook address URL (Optional - it can be shortened)
$hookurl = "YOUR_FULL_WEBHOOK_HERE"
# $hookurl = "https://t.ly/shrtlnk"

# RUN OPTIONS
# 1. Simple - Just a basic test message
# 2. Full   - A test message with Embedded Object
$RunVersion = "full" # Choose 'Simple' OR 'Full'

# Short URL detection
if ($hookurl.Length -ne 121) {
$hookurl = (irm $hookurl).url
Write-Host "Shortened URL detected." -ForegroundColor Green
$shortened = "`nShort URL detected and working..."
}
else{
Write-Host "Valid Webhook URL detected." -ForegroundColor Green
$shortened = "`nNo short URL detected..`n(You can test a shortened URL with this tool)"
}

Function WebhookSendMessage {

# Define the body of the message and convert it to JSON
$body = @{"username" = "Webhook-Test-BOT" ;"content" = "The webhook works!"} | ConvertTo-Json

# Use 'Invoke-RestMethod' command to send the message to Discord
IRM -Uri $hookurl -Method Post -ContentType "application/json" -Body $body

}

# Webhook notification with embed
Function WebhookSendEmbed{
$timestamp = Get-Date -Format "dd/MM/yyyy  @  HH:mm"
$hookOwner = (Irm -Uri $hookurl -Method Get).user
$Creator = $hookOwner.username
$hookName = (Irm -Uri $hookurl -Method Get).name
$hookChan = (Irm -Uri $hookurl -Method Get).channel_id
$hookGuild = (Irm -Uri $hookurl -Method Get).guild_id
# Create JSON object
$jsonPayload = @{
    username   = "Webhook-Test-BOT"
    content    = "@everyone The Webhook is Working!"
    avatar_url = "https://i.ibb.co/pPmrgMC/imgbin-computer-icons-fish-hook-png.png"
    tts        = $false
    embeds     = @(
        @{
            title       = "WEBHOOK TEST"
            description = "Your webhook is live!`n`nThis is a test post to confirm that messages and embeds are working as intended.`n$shortened`n`nWEBHOOK DETAILS:`nCreated By: ``$Creator```nWebhook Name: ``$hookName```nChannel ID: ``$hookChan```nServer ID: ``$hookGuild``"
            color       = 65280
            url         = "https://dsc.gg/whitehathacker"
            thumbnail   = @{
                url = "https://i.ibb.co/pPmrgMC/imgbin-computer-icons-fish-hook-png.png"
            }
            author      = @{
                name     = "egieb"
                url      = "https://github.com/beigeworm"
                icon_url = "https://i.ibb.co/vJh2LDp/img.png"
            }
            footer      = @{
                text = "$timestamp"
            }
        }
    )
}

# Convert to a JSON string and send to victim webhook
$jsonString = $jsonPayload | ConvertTo-Json -Depth 10 -Compress
Irm -Uri $hookurl -Method Post -Body $jsonString -ContentType 'application/json'
}

# Call function to send message
if ($RunVersion -match "full"){
    Write-Host "Full module selected - Sending message and embed to Discord" -ForegroundColor Green
    WebhookSendEmbed
}
elseif ($RunVersion -match "simple"){
    Write-Host "Simple module selected - Sending message to Discord" -ForegroundColor Green
    WebhookSendMessage
}
Else{
    Write-Host "No valid module selected - Please select 'simple' or 'full'" -ForegroundColor Red
}
