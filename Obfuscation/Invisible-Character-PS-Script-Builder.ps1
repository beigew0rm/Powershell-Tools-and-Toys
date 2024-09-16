<# ===================== Hide Powershell with Invisible Characters ========================

SYNOPSIS
This script takes powershell code from $payload variable and encodes it to invisible characters.
a new powersehll script is created with the hidden code in $p variable and accompanying decode function 

USAGE
1. Provide your code to be hidden in the $payload varable below.
2. Run this script to produce 'output.ps1' (the hidden payload script)
3. Running the 'output.ps1' file will decode your hidden payload and run it immediately

#>

# ================ Your code to be hidden goes here (inside $payload tag) ===================
$payload = '

# ========= EXAMPLE HIDDEN CODE =========
Write-Host "THIS IS A SECRET MESSAGE!" -ForegroundColor Green
Add-Type -AssemblyName System.Windows.Forms
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Shield
$notify.Visible = $true
$notify.ShowBalloonTip(3000, "Test Popup", "This is a test popup message", [System.Windows.Forms.ToolTipIcon]::Info)
Start-Sleep -Milliseconds 500

'
# ===========================================================================================

# Path to output file
$filePath = "output.ps1"

$nothingCharacters = @([char]0x034F, [char]0x200B, [char]0x200C, [char]0x200D )
$compressionFlags = @([char]0x200C,[char]0x200D)
$encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Payload))
$encodedBytes = [System.Text.Encoding]::UTF8.GetBytes($encodedCommand)
$nothings = $compressionFlags[0]

foreach ($byte in $encodedBytes) {
    for ($j = 0; $j -lt 4; $j++) {
        $twoBits = ($byte -shr (2 * $j)) -band 3
        $nothings += $nothingCharacters[$twoBits]
    }
}

$part1 = '$n=@([char]0x034F,[char]0x200B,[char]0x200C,[char]0x200D)
$c=@([char]0x200C,[char]0x200D);'

$part2 = "`$p='$nothings';`$a=`$p.ToCharArray();`$i=0"

$part3 = 'while($i-lt$a.Length-and$c.IndexOf($a[$i])-lt0){$i++}
if($i-eq$a.Length){return ""};$s=($a[$i]-eq$c[1]);$l=@()
for($i++;$i-lt$a.Length;$i+=4){if($n.IndexOf($a[$i])-lt0){break};$v=0
for($j=0;$j-lt4;$j++){$2=$n.IndexOf($a[$i+$j]);if($2-lt0){break};$v+=$2-shl(2*$j)}$l+=$v}
$d=[System.Text.Encoding]::UTF8.GetString([byte[]]$l)
$b=[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($d));$b|i`ex'

$part1 | Out-File -FilePath $filePath -NoNewline -Force
$part2 | Out-File -FilePath $filePath -Append -Force
$part3 | Out-File -FilePath $filePath -Append -Force