<#========================= Powershell Environment Variable Encoder =============================

SYNOPSIS
Uses powershell to encode a powershell command into environment variable indexes which can be ran in a PS console.
Based on John Hammonds Python code - https://www.youtube.com/watch?v=8CiNx4nNqQ0

USAGE
1. run the script
2. select if to pre encode the command (helpful if your command has ' or " or $ characters)
3. select if to save the final command as a .ps1 file (this file will run your original command)


# Example command (it will need to be fomatted differently some areas, like below)
# "write `"hi, this is obfuscated code`"`nwrite `"Variables created:a,b,c`";`$a =`"secret message`";`$b=```'ScriptKey```';`$c=`$true;write `"Directory set to: `$(`$env:USERPROFILE)`";cd `$env:USERPROFILE; write-output `"```$a = `$a | ```$b = `$b | ```$c = `$c`""
# OR you can use Pre-Encoding feature OR load from a .ps1file
 
#>

[Console]::BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(120, 40)
$windowTitle = "Powershell Environment Variable Encoder"
[Console]::Title = $windowTitle

$powershell_cmd = Read-Host "Enter your Powershell code (leave empty to specify a ps1 file instead) "

if ($powershell_cmd.Length -eq 0){
    $ps1File = Read-Host "Enter the path to your file "
    $powershell_cmd = Get-Content -Path $ps1File -Raw
}

$commandPreEncode = Read-Host "Pre encode the command? (helpful if your command has ' or `" or $ characters) [y/n]"
$outToFile = Read-Host "Save Output to file? (this file will run your original command) [y/n]"

$env_vars = @(
    "ALLUSERSPROFILE", 
    "CommonProgramFiles",
    "CommonProgramW6432",
    "ComSpec",
    "PATHEXT",
    "ProgramData",
    "ProgramFiles",
    "ProgramW6432",
    "PSModulePath",
    "PUBLIC",
    "SystemDrive",
    "SystemRoot",
    "windir"
)

$env_mapping = @{}
foreach ($var in $env_vars) {
    $value = [Environment]::GetEnvironmentVariable($var)
    if (-not [string]::IsNullOrEmpty($value)) {
        foreach ($character in $value.ToCharArray()) {
            if (-not $env_mapping.ContainsKey($character)) {
                $env_mapping[$character] = @{}
            }
            if (-not $env_mapping[$character].ContainsKey($var)) {
                $env_mapping[$character][$var] = @()
            }
            $env_mapping[$character][$var] += $value.IndexOf($character)
        }
    }
}

function envhide_obfuscate {
    param ([string]$string) 
    $obf_code = @()
    foreach ($c in $string.ToCharArray()) {
        $options = $env_mapping[$c].Keys
        if (-not $options) {
            $obf_code += "[char]$( [int][char]$c )"
            continue
        }
        $chosen = $options | Get-Random
        $possible_indices = $env_mapping[$c][$chosen]
        $chosen_index = $possible_indices | Get-Random
        $new_char = [Environment]::GetEnvironmentVariable($chosen)[$chosen_index]
        $pwsh_syntax = "`$env:$($chosen)[$($chosen_index)]"
        $obf_code += $pwsh_syntax
    }
    return $obf_code
}

function pwsh_obfuscate {
    param ([string]$string)
    $iex = envhide_obfuscate "iex"
    $pieces = envhide_obfuscate $string
    $iex_stage = "($( $iex -join ',' ) -Join `$($null))"
    $payload_stage = "($( $pieces -join ',' ) -Join `$($null))"
    return "& $iex_stage $payload_stage"
}
if ($commandPreEncode -eq 'y'){
    Write-Host "Original Command
================================
$powershell_cmd
================================
" -ForegroundColor DarkGray

    $toEncode = $powershell_cmd
    $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($toEncode))
    $fullCommand = "Start-Process PowerShell.exe -ArgumentList (`"-ep bypass -w h -e $encodedCommand`")"
    Write-Host "Encoded Command
================================
$fullCommand
================================
" -ForegroundColor Yellow

    $encoded = (pwsh_obfuscate $fullCommand)
}
else{
    Write-Host "Original Command
================================
$powershell_cmd
================================
" -ForegroundColor DarkGray
    $encoded = (pwsh_obfuscate $powershell_cmd)
}


Write-Host "FINAL Encoded Command
================================
$encoded
================================
" -ForegroundColor Cyan

if ($outToFile -eq 'y'){
    $encoded | Out-File -FilePath 'encoded.ps1' -Force
    Write-Host "================================

File saved to 'encoded.ps1'

================================" -ForegroundColor Green
}

pause

pause
