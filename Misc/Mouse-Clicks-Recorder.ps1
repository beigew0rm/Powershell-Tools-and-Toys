<# ================================== MOUSE CLICKS RECORDER =================================

SYNOPSIS
Record your mouse clicks and positions along with interval time between clicks.. (for loading screens etc.)
Play them back later and automate clicky tasks!

USAGE
1. Run the script and select an option

HELP
the click sequence file is located in your temp folder as 'sequence.ps1'
you can play it manually - Rightclick - 'Run with Powershell' then minimize the console window.

#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Console]::BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(50, 20)
[Console]::Title = "Mouse Click Recorder"

while ($true){


    $header = "
    ===============================================
    
    ===========  MOUSE CLICK RECORDER  ============
    
    ===============================================
    
    OPTIONS :
    
    1. Record Mouse Clicks
    2. Play Mouse Clicks
    3. Clean Up Temp Files & Exit
    4. Exit
    "
    cls
    Write-Host $header -ForegroundColor Cyan
    $option = Read-Host "Please Select an Option "
    
    if ($option -eq 1){
        $sequencefile = "$env:TEMP\sequence.ps1"
        $fullPath = (Get-Item $sequencefile).FullName
        $sequencefileforc = $fullPath -replace '\\', '\\'
        Write-Host "Creating a file.."
        
        "# ===================================== CLICK SEQUENCER ========================================" | Out-File -FilePath $sequencefile -Force 
        "Add-Type -AssemblyName System.Windows.Forms" | Out-File -FilePath $sequencefile -Append -Force

'Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class MouseSimulator {
        [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
        public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
        
        public const int MOUSEEVENTF_LEFTDOWN = 0x02;
        public const int MOUSEEVENTF_LEFTUP = 0x04;
        public const int MOUSEEVENTF_RIGHTDOWN = 0x08;
        public const int MOUSEEVENTF_RIGHTUP = 0x10;
        public const int MOUSEEVENTF_WHEEL = 0x0800;

        public static void LeftClick() {
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            System.Threading.Thread.Sleep(10);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
        }

        public static void RightClick() {
            mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
            System.Threading.Thread.Sleep(10);
            mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
        }

        public static void ScrollUp() {
            mouse_event(MOUSEEVENTF_WHEEL, 0, 0, 120, 0);
        }

        public static void ScrollDown() {
            mouse_event(MOUSEEVENTF_WHEEL, 0, 0, -120, 0);
        }
    }
"@' | Out-File -FilePath $sequencefile -Append -Force
        
        Write-Host "Setting up..." -ForegroundColor Yellow
        sleep 1

Add-Type @"
using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
public class MouseHook
{
    public delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    public const int WH_MOUSE_LL = 14;
    public const int WM_MOUSEWHEEL = 0x020A;

    private static HookProc _proc = HookCallback;
    private static IntPtr _hookID = IntPtr.Zero;

    private static Encoding encoding = Encoding.Unicode;
    private static string logFilePath = "$sequencefileforc";

    public static void Start()
    {
        _hookID = SetHook(_proc);
    }

    public static void Stop()
    {
        UnhookWindowsHookEx(_hookID);
    }

    private static IntPtr SetHook(HookProc proc)
    {
        using (var curProcess = System.Diagnostics.Process.GetCurrentProcess())
        using (var curModule = curProcess.MainModule)
        {
            return SetWindowsHookEx(WH_MOUSE_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
    {
        if (nCode >= 0 && wParam == (IntPtr)WM_MOUSEWHEEL)
        {
            int delta = Marshal.ReadInt32(lParam, 8);
            string message;
            if (delta > 0)
            {
                message = "[MouseSimulator]::ScrollUp()";
            }
            else if (delta < 0)
            {
                message = "[MouseSimulator]::ScrollDown()";
            }
            else
            {
                return CallNextHookEx(_hookID, nCode, wParam, lParam);
            }

            using (StreamWriter writer = new StreamWriter(logFilePath, true, encoding))
            {
                writer.WriteLine(message);
            }
        }
        return CallNextHookEx(_hookID, nCode, wParam, lParam);
    }

    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
}
"@

# Start the mouse hook
[MouseHook]::Start()

function MouseState {

    $previousState = [System.Windows.Forms.Control]::MouseButtons
    $previousPosition = [System.Windows.Forms.Cursor]::Position
    $lastClickTime = $null
    $lastClickPosition = $null
    $lastIntervalTime = $null
    $singleClickDetected = $false
    $intTime = Get-Date
    $interval = 1000
    while ($true) {
        $currentState = [System.Windows.Forms.Control]::MouseButtons
        $currentPosition = [System.Windows.Forms.Cursor]::Position
        $currentTime = Get-Date

        if ($previousState -ne $currentState) {
            if ($currentState -ne [System.Windows.Forms.MouseButtons]::None) {
                $mousePosition = [System.Windows.Forms.Cursor]::Position
                $button = "Left"
                if ($currentState -eq [System.Windows.Forms.MouseButtons]::Right) {
                    $button = "Right"
                }
                if ($lastClickTime -ne $null -and ($currentTime - $lastClickTime).TotalSeconds -le 1) {
                    $intTime = Get-Date
                    $interval = ($intTime - $lastIntervalTime).TotalSeconds
                    "Start-Sleep $interval" | Out-File -FilePath $sequencefile -Append -Force
                    "[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($($mousePosition.X), $($mousePosition.Y))" | Out-File -FilePath $sequencefile -Append -Force
                    "Start-Sleep -Milliseconds 200" | Out-File -FilePath $sequencefile -Append -Force
                    "[MouseSimulator]::${button}Click()" | Out-File -FilePath $sequencefile -Append -Force
                    "Start-Sleep -Milliseconds 50" | Out-File -FilePath $sequencefile -Append -Force
                    "[MouseSimulator]::${button}Click()" | Out-File -FilePath $sequencefile -Append -Force
                    Write-Host "Interval Time: $interval seconds" -ForegroundColor DarkGray
                    Write-Host "Double-Click Detected at X:$($mousePosition.X) Y:$($mousePosition.Y)!" -ForegroundColor DarkGray
                    $lastClickTime = $currentTime
                    $singleClickDetected = $false
                } else {
                    $lastClickTime = $currentTime
                    $lastClickPosition = $mousePosition
                    $lastIntervalTime = $intTime
                    $singleClickDetected = $true
                }
            }
            $previousState = $currentState
        }
        elseif ($singleClickDetected -and ($currentState -eq [System.Windows.Forms.MouseButtons]::None)) {
            if (($currentTime - $lastClickTime).TotalSeconds -gt 1) {
                $intTime = Get-Date
                $interval = ($intTime - $lastIntervalTime).TotalSeconds
                "Start-Sleep $interval" | Out-File -FilePath $sequencefile -Append -Force
                "[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($($mousePosition.X), $($mousePosition.Y))" | Out-File -FilePath $sequencefile -Append -Force
                "Start-Sleep -Milliseconds 200" | Out-File -FilePath $sequencefile -Append -Force
                "[MouseSimulator]::${button}Click()" | Out-File -FilePath $sequencefile -Append -Force
                Write-Host "Interval Time: $interval seconds" -ForegroundColor DarkGray
                Write-Host "Mouse Click Detected at X:$($lastClickPosition.X) Y:$($lastClickPosition.Y)! Button: $button" -ForegroundColor DarkGray
                $lastClickTime = $null
                $singleClickDetected = $false
            }
        }

        if ($previousPosition -ne $currentPosition) {
            $intTime = Get-Date
            $interval = ($intTime - $lastIntervalTime).Totalmilliseconds
            $lastIntervalTime = $intTime
            $previousPosition = $currentPosition
            "Start-Sleep -Milliseconds $interval" | Out-File -FilePath $sequencefile -Append -Force
            "[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($($currentPosition.X), $($currentPosition.Y))" | Out-File -FilePath $sequencefile -Append -Force
            Write-Host "Mouse Moved to X:$($currentPosition.X) Y:$($currentPosition.Y)" -ForegroundColor DarkGray
        }

        Start-Sleep -Milliseconds 20
    }
}

Write-Host "Recording..." -ForegroundColor Red
while ($true) {
    MouseState
}  

[MouseHook]::Stop()
     
    }
    
    if ($option -eq 2){
        Write-Host "Playing..." -ForegroundColor Yellow
        Get-Content -Path $sequencefile -Raw | iex
        Write-Host "Succeded!" -ForegroundColor Green
        sleep 3
    
    }
    
    if ($option -eq 3){
        Write-Host "Cleaning up..." -ForegroundColor yellow
        sleep 3
        $sequencefile = "$env:TEMP/sequence.ps1"
        rm -Path $sequencefile -Force
        Write-Host "Closing.." -ForegroundColor Red
        sleep 3
        exit
    }
    
    if ($option -eq 4){
        Write-Host "Closing.." -ForegroundColor Red
        sleep 3
        exit
    }
    
    else{
        Write-Host "Please choose a valid option." -ForegroundColor Red
        sleep 3
    }

}
