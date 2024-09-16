Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$Width = $screen.Bounds.Width
$Height = $screen.Bounds.Height
$X = [math]::Round($Width / 2)
$Y = [math]::Round($Height / 2)
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)