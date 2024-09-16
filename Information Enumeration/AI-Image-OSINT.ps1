<# ==================== AI IMAGE LOCATION FINDER =========================

SYNOPSIS
Uses https://picarta.ai to inspect a specified image and guess the location.

USAGE
1. Register a free account on picarta.ai.
2. Copy api token into this script.
3. Run the script (100 requests a month with a free account)

#>

$api_token = "YOUR_API_TOKEN_HERE"

$img = Read-Host "Enter the image filepath "
$url = "https://picarta.ai/classify"

$img_bytes = [System.IO.File]::ReadAllBytes("$img")
$img_base64 = [Convert]::ToBase64String($img_bytes)

$payload = @{
    "TOKEN" = $api_token
    "IMAGE" = $img_base64
}
$json_payload = $payload | ConvertTo-Json
$response = Invoke-RestMethod -Uri $url -Method Post -Headers @{"Content-Type"="application/json"} -Body $json_payload
Write-Output $response


