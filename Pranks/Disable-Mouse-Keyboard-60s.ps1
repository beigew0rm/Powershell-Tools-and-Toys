
$seconds = 60
$seconds | Out-File -FilePath "$env:TEMP\time.txt"

$job = {
$seconds = Get-Content -Path "$env:TEMP\time.txt"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$startTime = Get-Date
$endTime = $startTime.AddSeconds($seconds)
$time = Get-Date

$currentPosition = [System.Windows.Forms.Cursor]::Position
$x = $currentPosition.X
$y = $currentPosition.y

while ($time -le $endTime) {
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x,$y)
Start-Sleep -Milliseconds 10
}

}

$job2 = {
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class InterceptMouse
    {
        private const int WH_MOUSE_LL = 14;
        private const int WM_MOUSEMOVE = 0x0200;

        private static IntPtr hookID = IntPtr.Zero;
        private static LowLevelMouseProc hookCallback = HookCallback;

        public static void Main()
        {
            hookID = SetHook(hookCallback);
            System.Threading.Thread.Sleep(10000);
            UnhookWindowsHookEx(hookID);
        }

        private static IntPtr SetHook(LowLevelMouseProc proc)
        {
            using (var curProcess = System.Diagnostics.Process.GetCurrentProcess())
            using (var curModule = curProcess.MainModule)
            {
                return SetWindowsHookEx(WH_MOUSE_LL, proc,
                    GetModuleHandle(curModule.ModuleName), 0);
            }
        }

        private delegate IntPtr LowLevelMouseProc(int nCode, IntPtr wParam, IntPtr lParam);

        private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0 && wParam == (IntPtr)WM_MOUSEMOVE)
            {
                return (IntPtr)1; // Block mouse input
            }
            return CallNextHookEx(hookID, nCode, wParam, lParam);
        }

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr SetWindowsHookEx(int idHook,
            LowLevelMouseProc lpfn, IntPtr hMod, uint dwThreadId);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode,
            IntPtr wParam, IntPtr lParam);

        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr GetModuleHandle(string lpModuleName);
    }
"@
[InterceptMouse]::Main()
}

$job3 = {
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class InterceptKeyboard
    {
        private const int WH_KEYBOARD_LL = 13;
        private const int WM_KEYDOWN = 0x0100;
        private const int WM_KEYUP = 0x0101;

        private static IntPtr hookID = IntPtr.Zero;
        private static LowLevelKeyboardProc hookCallback = HookCallback;

        public static void Main()
        {
            hookID = SetHook(hookCallback);
            System.Threading.Thread.Sleep(10000); // Sleep for 10 seconds
            UnhookWindowsHookEx(hookID);
        }

        private static IntPtr SetHook(LowLevelKeyboardProc proc)
        {
            using (var curProcess = System.Diagnostics.Process.GetCurrentProcess())
            using (var curModule = curProcess.MainModule)
            {
                return SetWindowsHookEx(WH_KEYBOARD_LL, proc,
                    GetModuleHandle(curModule.ModuleName), 0);
            }
        }

        private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

        private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0 && (wParam == (IntPtr)WM_KEYDOWN || wParam == (IntPtr)WM_KEYUP))
            {
                return (IntPtr)1; // Block keyboard input
            }
            return CallNextHookEx(hookID, nCode, wParam, lParam);
        }

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr SetWindowsHookEx(int idHook,
            LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode,
            IntPtr wParam, IntPtr lParam);

        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr GetModuleHandle(string lpModuleName);
    }
"@

# Start the hook
[InterceptKeyboard]::Main()
}



sleep 1
Start-Job -ScriptBlock $job -Name replace
$startTime = Get-Date
while ((Get-Date) -lt ($startTime.AddSeconds($seconds))) {
    Start-Job -ScriptBlock $job2 -Name freezemouse
    Start-Job -ScriptBlock $job3 -Name freezekeys
    sleep 9
}
