<# ============================== Signed-EXE-and-DLL-Checker ========================================


SYNOPSIS
Check all exe and dll files in a selected folder if they are signed and whos signature in a table

USAGE
1. Run the script and select a folder to search.
2. Results are displayed in a table on completion.

#>

$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host
[Console]::Title = "Signed Programs Checker"
[Console]::SetWindowSize(50,20)

Add-Type -AssemblyName System.Windows.Forms

function Select-FolderDialog {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select a folder to scan for signed programs"
    $folderBrowser.ShowNewFolderButton = $false

    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
        $select = $folderBrowser.SelectedPath
        Write-Host "Selected Folder : $select" -ForegroundColor Gray
    } else {
        return $null
    }
}
Write-Host "Select A Folder To Search.." -ForegroundColor Cyan
$selectedFolder = Select-FolderDialog

if (-not $selectedFolder) {
    Write-Host "No folder selected. Exiting..." -ForegroundColor Red
    exit
}

$d = dir -Recurse $selectedFolder\*.exe
$d += dir -Recurse $selectedFolder\*.dll
$i = 0
$result = @()
[Console]::SetWindowSize(120,20)

foreach ($f in $d)
{
    $i += 1
    Write-Progress -PercentComplete (($i*100) / $d.Count) -Activity "Checking Signatures"
    $sig = Get-AuthenticodeSignature $f
    $sha1 = (Get-FileHash $f.FullName -Algorithm SHA1).Hash
    $subject = $sig.SignerCertificate.Subject

    if ($subject -match 'CN=([^,]+)')
    {
        $manufacturer = $matches[1]
    }
    else
    {
        $manufacturer = $subject
    }

    $status = if ($sig.IsOSBinary -or ($sig.Status -eq 'Valid')) {
        'Signed'
    } else {
        'Unsigned'
    }

    $statusIcon = if ($status -eq 'Signed') {
        "✅"
    } else {
        "❌"
    }

    $result += [PSCustomObject]@{
        'Status Icon' = $statusIcon
        'Status'      = $status
        'File Path'   = $f.FullName
        'Subject'     = $manufacturer
        'SHA1 Hash'   = $sha1
        
    }
}

Write-Host "Scan Completed" -ForegroundColor Green
$result | Out-GridView -Title "File Signature Scan Results"

[Console]::SetWindowSize(50,20)

Read-Host "Press any key to close.."