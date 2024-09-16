<#=============================== CLEAN UP =====================================

SYNOPSIS
Empty the temp folder and recycle bin, clear run box and powershell history

USAGE
1. Run the script

CREDIT
this code was pulled from I-Am-Jakoby's recon script. 

#>


# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue