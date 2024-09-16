<# ================ Screen Words Prank ==================

Synopsis
Runs hidden - and prints words transcribed from the microphone onto the desktop in random positions.


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

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$Width = $screen.Bounds.Width
$Height = $screen.Bounds.Height
$desktopHandle = [System.IntPtr]::Zero
$graphics = [System.Drawing.Graphics]::FromHwnd($desktopHandle)
$random = New-Object System.Random
function Get-RandomPosition {
    param (
        [int]$textWidth,
        [int]$textHeight
    )
    $x = $random.Next(0, $Width - $textWidth)
    $y = $random.Next(0, $Height - $textHeight)
    return [PSCustomObject]@{X = $x; Y = $y}
}

$textColor = [System.Drawing.Color]::Red
while ($true) {    
    Add-Type -AssemblyName System.Speech
    $speech = New-Object System.Speech.Recognition.SpeechRecognitionEngine
    $grammar = New-Object System.Speech.Recognition.DictationGrammar
    $speech.LoadGrammar($grammar)
    $speech.SetInputToDefaultAudioDevice()
    $result = $speech.Recognize()
    if ($result) {
        $text = $result.Text
        Write-Output $text
        $font = New-Object System.Drawing.Font("Arial", $random.Next(50, 100))
        $textSize = $graphics.MeasureString($text, $font)
        $textWidth = [math]::Ceiling($textSize.Width)
        $textHeight = [math]::Ceiling($textSize.Height)
        $position = Get-RandomPosition -textWidth $textWidth -textHeight $textHeight
        $graphics.DrawString($text, $font, (New-Object System.Drawing.SolidBrush($textColor)), $position.X, $position.Y)
        $font.Dispose()
    }
}