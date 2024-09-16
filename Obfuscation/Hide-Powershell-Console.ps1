<#================================ CONSOLE WINDOW HIDER ===================================

SYNOPSIS
Uses 'user32.dll' to hide the console window

USAGE
Add this code to the start of your Powershell scripts to hide the console window from the user
(the Powershell process will still be visible in task manager.)

CREDIT
All credit and kudos to I-Am-Jakoby for the function!

#>

# HIDE THE WINDOW - Change to 0 to show the console window
$HideWindow = 1
If ($HideWindow -gt 0){
$Import = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);';
add-type -name win -member $Import -namespace native;
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0);
}
