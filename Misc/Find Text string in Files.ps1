<#

========================= Mon's Text Finder ===========================

This Script searches all files in a given folder for any rows of text containing a given string.


USAGE
1. Run this script in powershell
2. results are output to the command line

#>

Clear-Host
$folderPath = Read-Host "Path to Search > "
$searchString = Read-Host "Text to Search > "
$showpath = Read-Host "Show Path to Matches? (y/n) "

$txtFiles = Get-ChildItem -Path $folderPath -Filter "*" -File -Recurse
$results = @()

Clear-Host
Start-Sleep 1
Write-Host "Searching Files... `n" -ForegroundColor Green

foreach ($file in $txtFiles) {
    $job = Start-Job -ScriptBlock {
        param($FilePath, $SearchString)
        $content = Get-Content -Path $FilePath | Select-String -Pattern $SearchString

        if ($content) {
            [PSCustomObject]@{
                FilePath = $FilePath
                Result = $content.Line
            }
        }
    } -ArgumentList $file.FullName, $searchString
    $results += $job
}

$results | Wait-Job
Start-Sleep 1
Clear-Host
Write-Host "Results > `n" -ForegroundColor Green

if ($showpath -eq "y"){

$output = $results | Receive-Job
foreach ($result in $output) {
    if ($result) {
        $file = Get-Item -Path $result.FilePath
        Write-Host "Match Found!" -ForegroundColor Green
        Write-Host "Filepath > $($file.FullName)" -ForegroundColor Gray
        foreach ($line in $result.Result) {
            Write-Host "$line `n" -ForegroundColor White
        }
    }
}

}
else{

$output = $results | Receive-Job
foreach ($result in $output) {
    if ($result) {
        $file = Get-Item -Path $result.FilePath
        Write-Host "Match Found!" -ForegroundColor Green
        foreach ($line in $result.Result) {
            Write-Host "$line `n" -ForegroundColor White
            }
        }
    }

}

$results | Remove-Job

Read-Host "Press any key to exit..."
