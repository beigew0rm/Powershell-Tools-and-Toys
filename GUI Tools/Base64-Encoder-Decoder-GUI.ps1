Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()

$MainWindow = New-Object System.Windows.Forms.Form
$MainWindow.ClientSize = '700,900'
$MainWindow.Text = "| Montools | Base64 Encode & Decode |"
$MainWindow.BackColor = "#242424"
$MainWindow.Opacity = 1
$MainWindow.TopMost = $false
$MainWindow.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\charmap.exe")

$TextInput = New-Object System.Windows.Forms.TextBox
$TextInput.Location = New-Object System.Drawing.Point(15, 100)
$TextInput.BackColor = "#eeeeee"
$TextInput.Width = 670
$TextInput.Height = 370
$TextInput.Multiline = $true
$TextInput.Scrollbars = "Vertical" 
$TextInput.Font = 'Microsoft Sans Serif,8,style=Bold'
$TextInput.add_MouseHover($showhelp)
$TextInput.name="input"

$TextInputHeader = New-Object System.Windows.Forms.Label
$TextInputHeader.Text = "Text to Encode/Decode"
$TextInputHeader.ForeColor = "#bcbcbc"
$TextInputHeader.AutoSize = $true
$TextInputHeader.Width = 25
$TextInputHeader.Height = 10
$TextInputHeader.Location = New-Object System.Drawing.Point(15, 80)
$TextInputHeader.Font = 'Microsoft Sans Serif,10,style=Bold'

$OutputBoxHeader = New-Object System.Windows.Forms.Label
$OutputBoxHeader.Text = "Output"
$OutputBoxHeader.ForeColor = "#bcbcbc"
$OutputBoxHeader.AutoSize = $true
$OutputBoxHeader.Width = 25
$OutputBoxHeader.Height = 10
$OutputBoxHeader.Location = New-Object System.Drawing.Point(15, 490)
$OutputBoxHeader.Font = 'Microsoft Sans Serif,10,style=Bold'

$OutputBox = New-Object System.Windows.Forms.TextBox 
$OutputBox.Multiline = $True;
$OutputBox.Location = New-Object System.Drawing.Size(15,510) 
$OutputBox.Width = 670
$OutputBox.Height = 370
$OutputBox.Scrollbars = "Vertical" 
$OutputBox.Font = 'Microsoft Sans Serif,8,style=Bold'

$EncodeBT = New-Object System.Windows.Forms.Button
$EncodeBT.Text = "Encode Text to Base64"
$EncodeBT.Width = 300
$EncodeBT.Height = 35
$EncodeBT.Location = New-Object System.Drawing.Point(25, 35)
$EncodeBT.Font = 'Microsoft Sans Serif,10,style=Bold'
$EncodeBT.BackColor = "#eeeeee"
$EncodeBT.add_MouseHover($showhelp)
$EncodeBT.name="encode"

$DecodeBT = New-Object System.Windows.Forms.Button
$DecodeBT.Text = "Decode Text from Base64"
$DecodeBT.Width = 300
$DecodeBT.Height = 35
$DecodeBT.Location = New-Object System.Drawing.Point(375, 35)
$DecodeBT.Font = 'Microsoft Sans Serif,10,style=Bold'
$DecodeBT.BackColor = "#eeeeee"
$DecodeBT.add_MouseHover($showhelp)
$DecodeBT.name="decode"

$MainWindow.controls.AddRange(@($TextInput,$EncodeBT,$DecodeBT,$OutputBox,$TextInputHeader,$OutputBoxHeader))



$EncodeBT.Add_Click({

Function Add-OutputBoxLine{
    Param ($outfeed) 
    $OutputBox.AppendText("`r`n$outfeed")
    $OutputBox.Refresh()
    $OutputBox.ScrollToCaret()
}


$plainText = $TextInput.Text

$encodedText = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($plainText))

Add-OutputBoxLine -Outfeed "$encodedText"

})


$DecodeBT.Add_Click({

Function Add-OutputBoxLine{
    Param ($outfeed) 
    $OutputBox.AppendText("`r`n$outfeed")
    $OutputBox.Refresh()
    $OutputBox.ScrollToCaret()
}

$b64 = $TextInput.Text

$decodedFile = [System.Convert]::FromBase64String($b64);$decodedText = [System.Text.Encoding]::UTF8.GetString($decodedFile);$decodedText | Out-File -FilePath "$env:temp/a.ps1" -Append

$outstring = Get-Content -Path "$env:temp/a.ps1"

Add-OutputBoxLine -Outfeed "$outstring"
})


 
$MainWindow.ShowDialog() | Out-Null
exit 
