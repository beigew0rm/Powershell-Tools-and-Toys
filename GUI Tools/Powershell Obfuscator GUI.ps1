Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()

$MainWindow = New-Object System.Windows.Forms.Form
$MainWindow.ClientSize = '700,900'
$MainWindow.Text = "| Beigetools | Powershell Obfuscator 3000 |"
$MainWindow.BackColor = "#242424"
$MainWindow.Opacity = 1
$MainWindow.TopMost = $false
$MainWindow.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\charmap.exe")

$TextInput = New-Object System.Windows.Forms.TextBox
$TextInput.Location = New-Object System.Drawing.Point(15, 160)
$TextInput.BackColor = "#eeeeee"
$TextInput.Width = 670
$TextInput.Height = 320
$TextInput.Multiline = $true
$TextInput.Scrollbars = "Vertical" 
$TextInput.Font = 'Microsoft Sans Serif,8,style=Bold'

$TextInputHeader = New-Object System.Windows.Forms.Label
$TextInputHeader.Text = "Text to Obfuscate"
$TextInputHeader.ForeColor = "#bcbcbc"
$TextInputHeader.AutoSize = $true
$TextInputHeader.Width = 25
$TextInputHeader.Height = 10
$TextInputHeader.Location = New-Object System.Drawing.Point(15, 140)
$TextInputHeader.Font = 'Microsoft Sans Serif,12,style=Bold'

$OutputBoxHeader = New-Object System.Windows.Forms.Label
$OutputBoxHeader.Text = "Output"
$OutputBoxHeader.ForeColor = "#bcbcbc"
$OutputBoxHeader.AutoSize = $true
$OutputBoxHeader.Width = 25
$OutputBoxHeader.Height = 10
$OutputBoxHeader.Location = New-Object System.Drawing.Point(15, 490)
$OutputBoxHeader.Font = 'Microsoft Sans Serif,12,style=Bold'

$OutputBox = New-Object System.Windows.Forms.TextBox 
$OutputBox.Multiline = $True;
$OutputBox.Location = New-Object System.Drawing.Size(15,510) 
$OutputBox.Width = 670
$OutputBox.Height = 370
$OutputBox.Scrollbars = "Vertical" 
$OutputBox.Font = 'Microsoft Sans Serif,8,style=Bold'

$start = New-Object System.Windows.Forms.Button
$start.Text = "Run"
$start.Width = 300
$start.Height = 35
$start.Location = New-Object System.Drawing.Point(25, 25)
$start.Font = 'Microsoft Sans Serif,10,style=Bold'
$start.BackColor = "#eeeeee"

$saveit = New-Object System.Windows.Forms.Button
$saveit.Text = "Save"
$saveit.Width = 300
$saveit.Height = 35
$saveit.Location = New-Object System.Drawing.Point(375, 25)
$saveit.Font = 'Microsoft Sans Serif,10,style=Bold'
$saveit.BackColor = "#eeeeee"

$stringsboxtext = New-Object System.Windows.Forms.Label
$stringsboxtext.Text = "Obfuscate Strings"
$stringsboxtext.ForeColor = "#bcbcbc"
$stringsboxtext.AutoSize = $true
$stringsboxtext.Width = 25
$stringsboxtext.Height = 10
$stringsboxtext.Location = New-Object System.Drawing.Point(55, 87)
$stringsboxtext.Font = 'Microsoft Sans Serif,10,style=Bold'

$stringsbox = New-Object System.Windows.Forms.CheckBox
$stringsbox.Width = 30
$stringsbox.Height = 30
$stringsbox.Location = New-Object System.Drawing.Point(35, 80)

$capitalboxtext = New-Object System.Windows.Forms.Label
$capitalboxtext.Text = "Change Capitalization"
$capitalboxtext.ForeColor = "#bcbcbc"
$capitalboxtext.AutoSize = $true
$capitalboxtext.Width = 25
$capitalboxtext.Height = 10
$capitalboxtext.Location = New-Object System.Drawing.Point(235, 87)
$capitalboxtext.Font = 'Microsoft Sans Serif,10,style=Bold'

$capitalbox = New-Object System.Windows.Forms.CheckBox
$capitalbox.Width = 30
$capitalbox.Height = 30
$capitalbox.Location = New-Object System.Drawing.Point(215, 80)

$MainWindow.controls.AddRange(@($TextInput,$start,$saveit,$OutputBox,$stringsboxtext,$stringsbox,$capitalboxtext,$capitalbox,$TextInputHeader,$OutputBoxHeader))



$start.Add_Click({

Function Add-OutputBoxLine{
    Param ($outfeed) 
    $OutputBox.AppendText("`r`n$outfeed")
    $OutputBox.Refresh()
    $OutputBox.ScrollToCaret()
}


$content = $TextInput.Text

if($stringsbox.Checked){

   $variables = [Regex]::Matches($content, '\$\w+') | Where-Object {$_.Value -ne '$_' -and $_.Value -ne '$env' -and $_.Value -ne '$line' -and $_.Value -ne '$true' -and $_.Value -ne '$false'} | ForEach-Object {
   $randomString = -join (48..57 + 65..90 + 97..122 | Get-Random -Count 6 | ForEach-Object {[char]$_})
   [PSCustomObject]@{
   OldVariable = $_.Value
   NewVariable = "$" + $randomString
   }
}
foreach ($variable in $variables) {
    $content = $content -replace [Regex]::Escape($variable.OldVariable), $variable.NewVariable
}
$filePath = "$env:temp/t.txt"
Set-Content -Path $filePath -Value $content
}



if($capitalbox.Checked){

$modifiedContent = ""

for ($i = 0; $i -lt $content.Length; $i++) {
    if ($i % 2 -eq 0) {
        $modifiedContent += $content[$i]
        }else {
        $modifiedContent += $content[$i].ToString().ToUpper()
        }
    
    }
$filePath = "$env:temp/t.txt"
Set-Content -Path $filePath -Value $modifiedContent
}
$textfile = Get-Content $filepath -Raw 
Add-OutputBoxLine -Outfeed "$textfile"
})


$saveit.Add_Click({

notepad "$env:temp/t.txt"

})


 
$MainWindow.ShowDialog() | Out-Null
exit 
