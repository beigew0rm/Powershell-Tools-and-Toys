<#========================= Live System Metrics Monitor ==============================

SYNPOSIS
Minature console window that outputs live system load information.

#>

# Set buffer size and window size
# Resize console and background
[console]::BufferWidth = [console]::WindowWidth = 50
[console]::BufferHeight = [console]::WindowHeight = 10

[Console]::BackgroundColor = "Black"
[Console]::Title = "System Metrics"
[Console]::CursorVisible = $false
Clear-Host

# Function for the output header
Function Header{
    Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Green
    Write-Host "++++              System Metrics             ++++" -ForegroundColor Green
    Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Green
}

# Credit and kudos to Dagnazty for this function 
function Get-PerformanceMetrics {

    $cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $memoryUsage = Get-Counter '\Memory\% Committed Bytes In Use' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $diskIO = Get-Counter '\PhysicalDisk(_Total)\Disk Transfers/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $networkIO = Get-Counter '\Network Interface(*)\Bytes Total/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime

    return [PSCustomObject]@{
        CPUUsage = "{0:F2}" -f $cpuUsage.CookedValue
        MemoryUsage = "{0:F2}" -f $memoryUsage.CookedValue
        DiskIO = "{0:F1}" -f $diskIO.CookedValue
        NetworkIO = "{0:F1}" -f $networkIO.CookedValue
        Uptime = (Get-Date) - $uptime
    }
}

# Function to generate bar charts
function DrawBar {
    param (
        [float]$value,
        [int]$maxBarLength = 20
    )
    $barLength = [math]::Round($value * $maxBarLength / 100)
    $bar = "#" * $barLength
    $emptySpace = " " * ($maxBarLength - $barLength)
    return "[$bar$emptySpace]"
}

# Function to check and handle alerts
function CheckAlerts {
    param(
        [float]$cpuUsage,
        [float]$memoryUsage,
        [float]$diskIO,
        [float]$networkIO
    )

    if ($cpuUsage -gt 80) {
        Write-Host "Alert: High CPU Usage!" -ForegroundColor Red
    }
    if ($memoryUsage -gt 80) {
        Write-Host "Alert: High Memory Usage!" -ForegroundColor Red
    }
    if ($diskIO -gt 100) {
        Write-Host "Alert: High Disk I/O!" -ForegroundColor Red
    }
    if ($networkIO -gt 1000000) { # Example threshold for network I/O
        Write-Host "Alert: High Network I/O!" -ForegroundColor Red
    }
}

# Loading Information
Header
Write-Host "`n@beigeworm | Discord - egieb" -ForegroundColor Gray
Write-Host "https://github.com/beigeworm"
sleep 2;cls
Header
Write-Host "`nLoading Performance Metrics.." -ForegroundColor Yellow
sleep 1
Write-Host "`Starting..." -ForegroundColor Green

# Main loop
while($true){
    $metrics = Get-PerformanceMetrics
    cls
    Header
    Write-Host "CPU Usage:     $(DrawBar -value $metrics.CPUUsage) $($metrics.CPUUsage)%"
    Write-Host "Memory Usage:  $(DrawBar -value $metrics.MemoryUsage) $($metrics.MemoryUsage)%"
    Write-Host "Disk I/O:      $($metrics.DiskIO) transfers/sec"
    Write-Host "Network I/O:   $($metrics.NetworkIO) bytes/sec"
    Write-Host "System Uptime: $($metrics.Uptime.Days) days, $($metrics.Uptime.Hours) hours"
    CheckAlerts -cpuUsage $metrics.CPUUsage -memoryUsage $metrics.MemoryUsage -diskIO $metrics.DiskIO -networkIO $metrics.NetworkIO
    Start-Sleep -Seconds 2
}
