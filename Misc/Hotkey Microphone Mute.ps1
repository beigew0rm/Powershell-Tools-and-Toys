<#
====================== Mute Connected Microphone W/ Home Key =========================

SYNOPNIS
Mutes/Unmutes your current microphone with a hotkey

USAGE
1.Run script and press the home key to toggle

#>


Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

Add-Type -TypeDefinition @"
using System;using System.Runtime.InteropServices;public class Audio {[DllImport("user32.dll", CharSet = CharSet.Auto)]public static extern IntPtr SendMessageW(IntPtr hWnd, int Msg, IntPtr wParam, IntPtr lParam);}
"@

$VK_HOME = 0x24  # Virtual key code
$a = "mute"

while ($true){
$keyState = [Keyboard]::GetAsyncKeyState($VK_HOME)

if ($keyState -band 0x8000){

if ($a -eq "mute"){
    Write-Host "Muted!"
    $WM_APPCOMMAND = 0x0319
    $APPCOMMAND_MICROPHONE_VOLUME_MUTE = 0x180000
    $handle = (Get-Process -PID $PID).MainWindowHandle
    [Audio]::SendMessageW($handle, $WM_APPCOMMAND, $handle, [IntPtr]::new($APPCOMMAND_MICROPHONE_VOLUME_MUTE)) | out-null
    $a = "unmute"
  }

else{
    Write-Host "Unmuted!"
    $WM_APPCOMMAND = 0x0319
    $APPCOMMAND_MICROPHONE_VOLUME_MUTE = 0x180000
    $handle = (Get-Process -PID $PID).MainWindowHandle 
    [Audio]::SendMessageW($handle, $WM_APPCOMMAND, $handle, [IntPtr]::new($APPCOMMAND_MICROPHONE_VOLUME_MUTE)) | out-null
    $a = "mute"
  }



}
Start-Sleep -Milliseconds 100
}





