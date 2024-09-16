<# ======================== Screen Edges Hurt [Prank] ===========================

SYNOPSIS
Everytime the mouse cursor touches the screen edges the classic Minecraft Player Damage sound plays.

USAGE
1. Run the script
2. Close in tray (Shield Icon)

(Runs hidden continuously)

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

iwr -Uri 'https://github.com/beigeworm/assets/raw/main/ouch.wav' -OutFile "$env:TEMP\sound.wav"


$Screenjob = {
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $Height = [math]::Round($screen.Bounds.Height - 1)
    $Width = [math]::Round($screen.Bounds.Width - 1)
    $hit = $false
    
    while ($true){
        $mousePosition = [System.Windows.Forms.Cursor]::Position
        if ($mousePosition.X -eq 0 -or $mousePosition.y -eq 0 -or $mousePosition.y -eq $Height -or $mousePosition.X -eq $Width -and $hit -eq $false){
            $job = {(New-Object Media.SoundPlayer "$env:TEMP\sound.wav").Play();sleep -M 500}
            Start-Job -ScriptBlock $job | Out-Null
            $hit = $true
        }
        elseif ($hit -eq $true){
            sleep -M 50
            if (!($mousePosition.X -eq 0 -or $mousePosition.y -eq 0 -or $mousePosition.y -eq $Height -or $mousePosition.X -eq $Width)){
                $hit = $false
            }
        }
        sleep -M 50
    }

}

Start-Job -ScriptBlock $Screenjob -Name master

Add-Type -AssemblyName System.Windows.Forms
$icon = New-Object System.Windows.Forms.NotifyIcon
$icon.Icon = [System.Drawing.SystemIcons]::Shield
$icon.Visible = $true

$menu = New-Object System.Windows.Forms.ContextMenuStrip

$exit = $menu.Items.Add("Close");
$exit.Image = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\DFDWiz.exe")

$icon.ContextMenuStrip = $menu
$app = New-Object System.Windows.Forms.ApplicationContext

$exit.add_Click({
    Get-Job -Name master | Stop-Job
    sleep 1 
    $app.ExitThread()
    sleep 2
    
})

[System.Windows.Forms.Application]::Run($app)
