Add-Type -AssemblyName System.Windows.Forms

$duration = 10  # Duration of the effect in seconds
$interval = 100  # Interval between flickers in milliseconds
$color1 = "Black"
$color2 = "Green"
$color3 = "Red"
$color4 = "Yellow"
$color5 = "Blue"
$color6 = "white"

$startTime = Get-Date

while ((Get-Date) -lt $startTime.AddSeconds($duration)) {
    $toggle = 1
    while ($toggle -lt 7){
    $form = New-Object System.Windows.Forms.Form
    $form.BackColor = $currentColor
    $form.FormBorderStyle = "None"
    $form.WindowState = "Maximized"
    $form.TopMost = $true
        # Toggle between colors
        if ($toggle -eq 1) {
            $currentColor = $color1
        }
        if ($toggle -eq 2) {
            $currentColor = $color2
        }
        if ($toggle -eq 3) {
            $currentColor = $color3
        }
        if ($toggle -eq 4) {
            $currentColor = $color4
        }
        if ($toggle -eq 5) {
            $currentColor = $color5
        }
        if ($toggle -eq 6) {
            $currentColor = $color6
        }
    $form.BackColor = $currentColor
    $form.Show()
    Start-Sleep -Milliseconds $interval
    $form.Close()
    $toggle++
    }
}

Write-Host "Flickering effect complete."