
<# ==================== Discord Message Backupper =========================

SYNOPSIS
Uses powershell along with Discord's API to retrieve all messages from all channels visible to the BOT

USAGE
1. Run script and enter your bot token when prompted
2. Messages will be saved to text files in the same directory as the script
#>

Add-Type -AssemblyName System.Drawing
[Console]::BackgroundColor = "Black"
[Console]::SetWindowSize(90, 40)
[Console]::Title = "Discord Messages Backup"
[Console]::CursorVisible = $false
cls

$token = Read-Host "Enter Your Bot Token "
function SaveAllMessages {
    Write-Host "Starting Message Backup" -ForegroundColor Green
    $headers = @{
        'Authorization' = "Bot $token"
    }
    # Initialize a web client
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("Authorization", $headers.Authorization)
    # Get list of guilds
    Write-Host "Retrieving Guilds.." -ForegroundColor DarkGray
    $guildsResponse = $webClient.DownloadString("https://discord.com/api/v9/users/@me/guilds")
    $guilds = $guildsResponse | ConvertFrom-Json
    # Iterate through each guild
    foreach ($guild in $guilds) {
        $guildId = $guild.id
        $guildName = $guild.name
        Write-Host "Guild Found: $guildName" -ForegroundColor Green
        # Get list of channels in the guild
        $channelsResponse = $webClient.DownloadString("https://discord.com/api/v9/guilds/$guildId/channels")
        $channels = $channelsResponse | ConvertFrom-Json
        # Iterate through each channel
        foreach ($channel in $channels) {
            # Only process readable text channels
            if ($channel.type -eq 0) {
                $channelId = $channel.id
                $channelName = $channel.name
                Write-Host "Recovering all messages from : $channelName" -ForegroundColor Gray
                # Download all messages from the channel
                $allMessages = @()
                $before = $null
                # Discord API limits the number of messages per request
                $limit = 50
                $hasMoreMessages = $true
                # Create a file to save messages
                $fileName = "${guildName} - ${channelName}.txt"
                # Continue downloading messages until no more are found
                while ($hasMoreMessages) {
                    # API endpoint to get messages
                    sleep 1
                    $messagesUrl = "https://discord.com/api/v9/channels/$channelId/messages?limit=$limit"
                    if ($before) {
                        $messagesUrl += "&before=$before"
                    }                
                    $response = $webClient.DownloadString($messagesUrl)
                    $messages = $response | ConvertFrom-Json
                    if ($messages) {
                        # Save messages to the file
                        foreach ($message in $messages) {
                            # Replace 'T' with a space
                            $formattedTimestamp = $message.timestamp -replace 'T', ' '
                            # Remove the fraction of a second and timezone offset
                            $formattedTimestamp = $formattedTimestamp -replace '\.\d+(\+|-)\d{2}:\d{2}$', ''
                            # Add the message with the formatted timestamp to the file
                            Add-Content -Path $fileName -Value "$formattedTimestamp - $($message.author.username): $($message.content)"
                        }
                        # Update the 'before' parameter for the next request
                        $before = $messages[-1].id
                    } else {
                        # No more messages to download
                        $hasMoreMessages = $false
                    }
                }
            }
        }
    }
}

SaveAllMessages -token $token
