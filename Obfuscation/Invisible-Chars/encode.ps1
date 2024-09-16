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

$filePath = "output.log"
$containerMessage = Read-Host "Container String "
$payloadMessage = Read-Host "Secret String "

$encodedMessage = Encode-Message -Container $containerMessage -Payload $payloadMessage
Write-Host "Encoded Message: $encodedMessage" -ForegroundColor Green
    
$encodedMessage | Out-File -FilePath $filePath