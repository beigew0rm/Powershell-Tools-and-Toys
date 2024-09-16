<#========================== CIPHER / DECIPHER TEXT TOOL =====================

SYNOPSIS
Cipher and Decipther text with a given key.

USAGE
1. Run and follow instructions
#>

[Console]::BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(70, 25)
[Console]::Title = " Cipher / Decipher Tool"

function Cipher-Text {
    param ([string]$text,[string]$key)
    $result = ""
    for ($i = 0; $i -lt $text.Length; $i++) {
        $charCode = [int]$text[$i] -bxor [int]$key[$i % $key.Length]
        $result += [char]$charCode
    }
    return [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($result))
}

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

Function Header {
cls
Write-Host "
===================================================================
=                                                                 =
=                          CIPHER TOOL                            =
=                                                                 =
===================================================================" -ForegroundColor Green
}

while($true){

Header
$seperator = ("-" * 30)

$operation = Read-Host "
===================================================================
=                                                                 =
= 1. Encrypt Text                                                 =
= 2. Decrypt Text                                                 =
=                                                                 =
===================================================================
Please choose an option "

    if($operation -eq '1'){
        Header
        $key = Read-Host "Enter a keyphrase "
        $text = Read-Host "Enter text to be encrypted "
        Header
        Write-Host "Keyphrase: $key" -ForegroundColor DarkGray
        Write-Host "Original Text: $text" -ForegroundColor DarkGray
        Write-Host $seperator
        $encryptedText = Cipher-Text -text $text -key $key
        Write-Host "Encrypted Text: $encryptedText"
        Write-Host $seperator
        pause
    }
    if($operation -eq '2'){
        Header
        $key = Read-Host "Enter the keyphrase "
        $encryptedText = Read-Host "Enter encrypted message "

        Header
        Write-Host "Keyphrase: $key" -ForegroundColor DarkGray
        Write-Host "Encrypted Text: $encryptedText" -ForegroundColor DarkGray
        Write-Host $seperator
        $decryptedText = Decipher-Text -encodedText $encryptedText -key $key
        Write-Host "Decrypted Text: $decryptedText"
        Write-Host $seperator
        pause
    }
    else{
    }

}
