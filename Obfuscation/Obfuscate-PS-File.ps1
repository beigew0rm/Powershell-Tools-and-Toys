<#
========================= Beigeworm's Basic Powershell Script Obfuscator ============================

SYNOPSIS
This script converts the contents of a .ps1 file and can change variable names and capitalization.

USAGE
1. open terminal in the folder this is placed in and run the script
2. select the script to modify in the file browser prompt.

EXAMPLE COMMAND
./Obfuscate-PS-File.ps1 -strings              // Obfuscate just variable names
./Obfuscate-PS-File.ps1 -strings -capitals    // Obfuscate variable names and change capitalization

#>

param([Switch] $Strings,[Switch] $Capitals)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$FileDialog = New-Object Windows.Forms.OpenFileDialog
$FileDialog.Filter = "All Files (*.*)|*.*"

if ($FileDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
$FilePath = $FileDialog.FileName
}

$content = Get-Content -Path $filePath -Raw

try {

if ($Strings) {

       $variables = [Regex]::Matches($content, '\$\w+') | Where-Object {$_.Value -ne '$_' -and $_.Value -ne '$env' -and $_.Value -ne '$line' -and $_.Value -ne '$true' -and $_.Value -ne '$false'} | ForEach-Object {
       $randomString = -join (48..57 + 65..90 + 97..122 | Get-Random -Count 6 | ForEach-Object {[char]$_})
       [PSCustomObject]@{
       OldVariable = $_.Value
       NewVariable = "$" + $randomString
       }
    }
    foreach ($variable in $variables) {
        $content = $content -replace [Regex]::Escape($variable.OldVariable), $variable.NewVariable
    }
    Set-Content -Path $filePath -Value $content

}

if ($Capitals) {

    $modifiedContent = ""

    for ($i = 0; $i -lt $content.Length; $i++) {
        if ($i % 2 -eq 0) {
            $modifiedContent += $content[$i]
            }else {
            $modifiedContent += $content[$i].ToString().ToUpper()
            }
        
        }

    $modifiedContent | Set-Content $filePath
    }






}
catch{

Write-Error "An error occurred: $_"



}