
<#
#============================================= beigeworm's Mouse Monitor ========================================================

SYNOPSIS
This script gathers information about any mouse movement and idletime and saves it to a file".


USAGE
2. Run Script on target System
3. Check temp folder for results

#>

$signature = @'
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool GetCursorPos(out POINT lpPoint);
[StructLayout(LayoutKind.Sequential)]
public struct POINT
{
    public int X;
    public int Y;
}
'@ 

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$outpath = "$env:temp\info.txt"
$cursorType = Add-Type -MemberDefinition $signature -Name "CursorPos" -Namespace "Win32" -PassThru
$prevX = 0
$idleThreshold = New-TimeSpan -Seconds 60
$lastActivityTime = [System.DateTime]::Now
$isActive = $true
$iActive = $true
sleep 1

while ($true) {
    $cursorPos = New-Object Win32.CursorPos+POINT
    [Win32.CursorPos]::GetCursorPos([ref]$cursorPos) | Out-Null
    $currentX = $cursorPos.X
    $currentTime = [System.DateTime]::Now

    if ($currentX -ne $prevX) {
        if ($iActive) {
        $prevX = $currentX
        $lastActivityTime = $currentTime
        
        if ($idleTime -lt $idleThreshold) {
        Write-Host "Mouse active"
        "[$timestamp] : Mouse is active" | Out-File -FilePath $outpath -Encoding ASCII -Append
        }
        $iActive = $false
    }
}
else {
        $iActive = $true
    }


    $idleTime = $currentTime - $lastActivityTime

    if ($idleTime -ge $idleThreshold) {
        if ($isActive) {
            Write-Host "Mouse was active in the past 60 seconds"
            "[$timestamp] : Mouse has been inactive for 60 seconds" | Out-File -FilePath $outpath -Encoding ASCII -Append
            $isActive = $false
            $iActive = $true
        }
        else {
        }
    }
    else {
        $isActive = $true
    }
    Start-Sleep -Milliseconds 60
}

