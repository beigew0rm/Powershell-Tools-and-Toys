<#=================  Webhook Removal Tool  ====================

SYNOPSIS
Remove webhooks within powershell.

USAGE
1. Supply a webhook below or when the script runs.
2. Check Discord for results.

#>

# supply a webhook here or when you run the script
$hookurl = "WEBHOOK_TO_REMOVE"

# Webhook shortened URL handler
$hookurl = (irm $hookurl).url

try{
    Write-Host "Checking for a webhook.." -ForegroundColor DarkGray
    # check if a webhook was pre-supplied
    if ($hookurl.Length -ne 121){
        # ask for a valid webhook
        Write-Host "No valid webhook supplied.." -ForegroundColor Yellow
        $hookurl = Read-Host "Enter a webhook to remove "
    }
    else{
        Write-Host "Valid webhook supplied.." -ForegroundColor Green
    }

# Send a delete command to the webhook
$response = IRM -Uri $hookUrl -Method Delete -ContentType "application/json"
Write-Host "Webhook successfully removed" -ForegroundColor Green
}
catch{
# If webhook doesnt exist
Write-Host "Error : The webhook was not found" -ForegroundColor Red
Write-Output $response
}
