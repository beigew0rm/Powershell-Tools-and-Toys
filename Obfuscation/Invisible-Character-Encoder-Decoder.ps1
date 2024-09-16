<# ======================== Invisible Character Encoder and Decoder ===================================

SYNOPSIS
    This script encodes and decodes secret messages by embedding them into a container string or file using invisible characters. These characters are not visible in most text editors or display interfaces, making the hidden messages difficult to detect.

DESCRIPTION
    The script allows the user to encode a payload (or secret message) into a container string or file by converting the payload into a sequence of invisible characters. These characters are then appended to the container message or file, making the hidden message appear invisible. The script also supports decoding, where it reads the invisible characters from a string or file and reconstructs the original hidden message.

    The script also features a simple file selection GUI for file-based encoding and decoding.

USAGE
    1. Encode a message into a string:
        - Run the script and select option 1.
        - Enter the container string where the hidden message will be embedded.
        - Enter the secret message to encode.
        - The encoded message will be displayed, containing the hidden message embedded as invisible characters.

    2. Encode a message into a file:
        - Run the script and select option 2.
        - Select the file into which you want to embed the secret message.
        - Enter the secret message to encode.
        - The file will be updated with the encoded message embedded as invisible characters.

    3. Decode a hidden message from a string:
        - Run the script and select option 3.
        - Enter the string containing the hidden message.
        - The decoded secret message will be displayed.

    4. Decode a hidden message from a file:
        - Run the script and select option 4.
        - Select the file from which you want to extract the hidden message.
        - The decoded secret message will be displayed.

    5. Exit:
        - To exit the script, select option 0.


NOTES
    - This script uses PowerShell and the .NET Framework for encoding and decoding.
    - It works best in environments where invisible characters are not stripped or altered (e.g., plain text files).
    - The invisible characters might be visible in hex editors or similar tools.

#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(70, 30)
[Console]::Title = "Invisible Character Encoder & Decoder"

# Define invisible characters for encoding
$nothingCharacters = @(
    [char]0x034F, 
    [char]0x200B, 
    [char]0x200C, 
    [char]0x200D 
)

$compressionFlags = @(
    [char]0x200C,
    [char]0x200D
)

# Encode a payload inside a container message
function Encode-Message {
    param (
        [string]$Container,
        [string]$Payload
    )
    
    $encodedBytes = [System.Text.Encoding]::UTF8.GetBytes($Payload)
    $nothings = $compressionFlags[0]
    
    foreach ($byte in $encodedBytes) {
        for ($j = 0; $j -lt 4; $j++) {
            $twoBits = ($byte -shr (2 * $j)) -band 3
            $nothings += $nothingCharacters[$twoBits]
        }
    }
    
    return $Container + $nothings
}

# Decode the hidden payload from an encoded message
function Decode-Message {
    param (
        [string]$Message
    )

    $characters = $Message.ToCharArray()
    $i = 0

    while ($i -lt $characters.Length -and $compressionFlags.IndexOf($characters[$i]) -lt 0) {
        $i++
    }
    
    if ($i -eq $characters.Length) {
        return ""
    }
    
    $isCompressed = ($characters[$i] -eq $compressionFlags[1])
    $list = @()

    for ($i++; $i -lt $characters.Length; $i += 4) {
        if ($nothingCharacters.IndexOf($characters[$i]) -lt 0) {
            break
        }
        $value = 0
        for ($j = 0; $j -lt 4; $j++) {
            $twoBits = $nothingCharacters.IndexOf($characters[$i + $j])
            if ($twoBits -lt 0) {
                break
            }
            $value += $twoBits -shl (2 * $j)
        }
        $list += $value
    }

    $decodedMessage = [System.Text.Encoding]::UTF8.GetString([byte[]]$list)
    return $decodedMessage
}

function Select-File {
    $fileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    [void]$fileBrowser.ShowDialog()
    return $fileBrowser.FileName
}


$optionlist = "
================================================
      Invisible Character Encoder & Decoder
================================================
1. Encode String
2. Encode File
3. Decode String
4. Decode File
0. Exit
================================================
"

Write-Host $optionlist -ForegroundColor Cyan
$optionSelect = Read-Host "Choose an option "
Clear-Host

While ($optionSelect -ne '0'){

    if ($optionSelect -eq '1'){
    
        $containerMessage = Read-Host "Container String "
        $payloadMessage = Read-Host "Secret String "
    
        try{
            $encodedMessage = Encode-Message -Container $containerMessage -Payload $payloadMessage
            Write-Host "Encoded Message: $encodedMessage" -ForegroundColor Green
    
            # $encodedMessage | Out-File -FilePath 'output.log'
        }
        catch{
            Write-Host "ERROR : $_"
        }
    
    }
    
    if ($optionSelect -eq '3'){
    
        $encodedMessage = Read-Host "String to decode "
    
        try{
            $decodedMessage = Decode-Message -Message $encodedMessage
            Write-Host "Decoded Message: $decodedMessage" -ForegroundColor Green
        }
        catch{
            Write-Host "ERROR : $_"
        }
    }
    
    if ($optionSelect -eq '2'){
        $filePath = Select-File
        Write-Host "Selected File: $filePath" -ForegroundColor Green
        $containerMessage = Get-Content -Path $filePath -Raw
    
        try{
            $payloadMessage = Read-Host "Secret String "
            $encodedMessage = Encode-Message -Container $containerMessage -Payload $payloadMessage
            Write-Host "Encoded Message: $encodedMessage" -ForegroundColor Green
            $encodedMessage | Out-File -FilePath $filePath
        }
        catch{
            Write-Host "ERROR : $_"
        }
    }
    
    if ($optionSelect -eq '4'){
        $filePath = Select-File
        Write-Host "Selected File: $filePath" -ForegroundColor Green
        try{
            $encodedMessage = Get-Content -Path $filePath -Raw
            $decodedMessage = Decode-Message -Message $encodedMessage
            Write-Host "Decoded Message: $decodedMessage" -ForegroundColor Green
            # "Decoded Message: $decodedMessage" | Out-File -FilePath 'output.log'
        }
        catch{
            Write-Host "ERROR : $_"
        }
    }
    
    pause

}

Write-Host "Exiting Script.." -ForegroundColor Red 
sleep 1
