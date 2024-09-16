
<# =================== Github Repository Powershell Scan and Invoke =======================

SYNOPSIS
Uses a Github personal access token to enumerate all powershell files within a specified public repository on github

USAGE
1. Go to your github settings by clicking your user avatar in the top right
2. Go to developer settings > Personal Access Tokens > Tokens (classic)
3. Click Generate Token (classic) - tick 'read public repositories' before generating
4. Paste token into the script along with your github username below
4. Specify the repository you would like to search
5. Run the script and select from the list - a new powershell process will spawn to run the selected script

#>

[Console]::BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(140, 50)
$windowTitle = "Powershell Github Invoker"
[Console]::Title = $windowTitle

function Header {
cls
$Header = "
▄▄▄  ▄▄▄ . ▄▄▄·      .▄▄ · ▪  ▄▄▄▄▄      ▄▄▄   ▄· ▄▌  .▄▄ ·  ▄▄·  ▄▄▄·  ▐ ▄  ▐ ▄ ▄▄▄ .▄▄▄  
▀▄ █·▀▄.▀·▐█ ▄█ ▄█▀▄ ▐█ ▀. ██ •██   ▄█▀▄ ▀▄ █·▐█▪██▌  ▐█ ▀. ▐█ ▌▪▐█ ▀█ •█▌▐█•█▌▐█▀▄.▀·▀▄ █·
▐▀▀▄ ▐▀▀▪▄ ██▀·▐█▌.▐▌▄▀▀▀█▄▐█· ▐█.▪▐█▌.▐▌▐▀▀▄ ▐█▌▐█▪  ▄▀▀▀█▄██ ▄▄▄█▀▀█ ▐█▐▐▌▐█▐▐▌▐▀▀▪▄▐▀▀▄ 
▐█•█▌▐█▄▄▌▐█▪·•▐█▌.▐▌▐█▄▪▐█▐█▌ ▐█▌·▐█▌.▐▌▐█•█▌ ▐█▀·.  ▐█▄▪▐█▐███▌▐█▪ ▐▌██▐█▌██▐█▌▐█▄▄▌▐█•█▌
.▀  ▀ ▀▀▀ .▀    ▀█▄▀▪ ▀▀▀▀ ▀▀▀ ▀▀▀  ▀█▄▀▪.▀  ▀  ▀ •    ▀▀▀▀ ·▀▀▀  ▀  ▀ ▀▀ █▪▀▀ █▪ ▀▀▀ .▀  ▀
`n"
Write-Host "$header" -ForegroundColor Green
}
Header

# Define GitHub credentials
$githubUsername = "YOUR_GITHUB_USERNAME" # Your Github Username
$githubToken = "YOUR_GITHUB_PERSONAL_ACCESS_TOKEN" # Your Personal Access Token

# Define repository details
$repoOwner = "beigeworm" # Tartget User
$repoName = "Powershell-Tools-and-Toys" # Target Public Repository

# Construct the GitHub API URL
$apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/contents"

# Define a function to retrieve file URLs and filenames recursively
function Get-FileDetails {
    param (
        [string]$url
    )

    $fileDetails = @()

    $response = Invoke-RestMethod -Uri $url -Headers @{
        Authorization = "token $githubToken"
    }

    foreach ($item in $response) {
        if ($item.type -eq "file") {
            if ($item.name -like "*.ps1") {
                $fileDetails += [PSCustomObject]@{
                    Name = $item.name
                    URL = $item.download_url
                }
            }
        } elseif ($item.type -eq "dir") {
            $fileDetails += Get-FileDetails -url $item.url
        }
    }

    return $fileDetails
}

# Call the function to get file details
$fileDetails = Get-FileDetails -url $apiUrl

# Generate a list of filenames
$scriptNames = $fileDetails.Name
# Prompt the user to select a script

while ($true){

    Header

    # Define a function to display script names in two columns
    function Display-ScriptNames {
        param (
            [string[]]$scriptNames
        )
    
        $columnWidth = 60
        $numColumns = [Math]::Ceiling($scriptNames.Count / 2)
    
        for ($i = 0; $i -lt $numColumns; $i++) {
            $index1 = $i * 2
            $index2 = $index1 + 1
            $script1 = if ($index1 -lt $scriptNames.Count) { $scriptNames[$index1] } else { "" }
            $script2 = if ($index2 -lt $scriptNames.Count) { $scriptNames[$index2] } else { "" }
    
            Write-Host -NoNewline ("{0}. {1,-$columnWidth}" -f ($index1 + 1), $script1) -ForegroundColor Cyan
            Write-Host ("| {0}. {1,-$columnWidth}" -f ($index2 + 1), $script2) -ForegroundColor Cyan
        }
    }

    Write-Host "Available scripts:" -ForegroundColor Green
    Display-ScriptNames -scriptNames $scriptNames

    do {
        [int]$selection = Read-Host "Enter the number of the script you want to invoke"
    } 
    until ($selection -ge 1 -and $selection -le $scriptNames.Count)

    if ($selection -ge 1 -and $selection -le $scriptNames.Count) {
        $selectedScript = $fileDetails[$selection - 1]
        $url = $($selectedScript.URL)
        Write-Host $url -ForegroundColor DarkGray
        Write-Host "You selected $($selectedScript.Name)" -ForegroundColor Green
        $tg = Read-Host "Enter a Telegram Bot Token (Optional) "
        $dc = Read-Host "Enter a Discord webhook (Optional) "

        $fpath = $PWD.Path
        $HideURL = "https://raw.githubusercontent.com/beigeworm/assets/main/master/Hide-Powershell-Console.ps1"
        $hidden = Read-Host "Would you like to run this in a hidden window? (Y/N)"
        If ($hidden -eq 'y'){
            Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -W Hidden -C irm $HideURL | iex ; cd $fpath;`$tg = `'$tg`' ;`$dc = `'$dc`' ; irm $url | iex")
        }
        else{
            Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -C cd $fpath; `$tg = `'$tg`' ;`$dc = `'$dc`' ; irm $url | iex")
        }
        
    } else {
        Write-Host "Invalid selection"
    }
}
