Add-Type -AssemblyName PresentationCore, PresentationFramework


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

# Create WPF Window
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="System Metrics" Height="420" Width="600" WindowStartupLocation="CenterScreen">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <TextBlock Text="System Metrics" FontSize="20" FontWeight="Bold" Foreground="Green" HorizontalAlignment="Center" Margin="10"/>
        <StackPanel Grid.Row="1" Margin="10">
            <TextBlock Name="SystemNameText" FontSize="14"/>
            <TextBlock Name="OSText" FontSize="14"/>
            <TextBlock Name="TotalMemoryText" FontSize="14"/>
            <TextBlock Name="AvailableMemoryText" FontSize="14"/>
            <TextBlock Name="DiskUsageText" FontSize="14"/>
            <TextBlock Name="CPUUsageText" FontSize="14"/>
            <ProgressBar Name="CPUUsageBar" Height="20" Margin="0,0,0,10"/>
            <TextBlock Name="MemoryUsageText" FontSize="14"/>
            <ProgressBar Name="MemoryUsageBar" Height="20" Margin="0,0,0,10"/>
            <TextBlock Name="DiskIOText" FontSize="14"/>
            <TextBlock Name="NetworkIOText" FontSize="14"/>
            <TextBlock Name="NetworkInterfacesText" FontSize="14"/>
            <TextBlock Name="UptimeText" FontSize="14"/>
            <TextBlock Name="CPUTemperatureText" FontSize="14"/>
            <TextBlock Name="BatteryStatusText" FontSize="14"/>
        </StackPanel>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$SystemNameText = $window.FindName("SystemNameText")
$OSText = $window.FindName("OSText")
$TotalMemoryText = $window.FindName("TotalMemoryText")
$AvailableMemoryText = $window.FindName("AvailableMemoryText")
$DiskUsageText = $window.FindName("DiskUsageText")
$CPUUsageText = $window.FindName("CPUUsageText")
$CPUUsageBar = $window.FindName("CPUUsageBar")
$MemoryUsageText = $window.FindName("MemoryUsageText")
$MemoryUsageBar = $window.FindName("MemoryUsageBar")
$DiskIOText = $window.FindName("DiskIOText")
$NetworkIOText = $window.FindName("NetworkIOText")
$NetworkInterfacesText = $window.FindName("NetworkInterfacesText")
$UptimeText = $window.FindName("UptimeText")
$CPUTemperatureText = $window.FindName("CPUTemperatureText")
$BatteryStatusText = $window.FindName("BatteryStatusText")

Function Get-PerformanceMetrics {
    $cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $memoryUsage = Get-Counter '\Memory\% Committed Bytes In Use' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $diskIO = Get-Counter '\PhysicalDisk(_Total)\Disk Transfers/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $networkIO = Get-Counter '\Network Interface(*)\Bytes Total/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime

    $systemInfo = Get-CimInstance -ClassName Win32_ComputerSystem
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $totalMemory = [math]::Round($systemInfo.TotalPhysicalMemory / 1GB, 2)
    $availableMemory = [math]::Round(($osInfo.TotalVisibleMemorySize - $osInfo.FreePhysicalMemory) / 1MB, 2)

    $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
    $diskUsageTotal = 0
    foreach ($disk in $diskInfo) {
        $diskUsageTotal += ($disk.Size - $disk.FreeSpace)
    }
    $diskUsage = [math]::Round($diskUsageTotal / 1GB, 2)

    $networkInterfaces = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | Select-Object -ExpandProperty Description

    # Getting CPU Temperature (requires administrative privileges)
    try {
        $cpuTemp = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" | Select-Object CurrentTemperature
        $cpuTemp = ($cpuTemp.CurrentTemperature - 2732) / 10.0
    } catch {
        $cpuTemp = "N/A"
    }

    # Getting Battery Status (for laptops)
    $battery = Get-WmiObject -Class Win32_Battery
    $batteryStatus = if ($battery) { "$($battery.EstimatedChargeRemaining)% ($($battery.BatteryStatus))" } else { "N/A" }

    return [PSCustomObject]@{
        SystemName = $systemInfo.Name
        OS = $osInfo.Caption
        TotalMemory = "$totalMemory GB"
        AvailableMemory = "$availableMemory MB"
        DiskUsage = "$diskUsage GB used"
        CPUUsage = "{0:F2}" -f $cpuUsage.CookedValue
        MemoryUsage = "{0:F2}" -f $memoryUsage.CookedValue
        DiskIO = "{0:F1}" -f $diskIO.CookedValue
        NetworkIO = "{0:F1}" -f $networkIO.CookedValue
        NetworkInterfaces = $networkInterfaces -join ", "
        Uptime = (Get-Date) - $uptime
        CPUTemperature = if ($cpuTemp -ne "N/A") { "{0:F1} °C" -f $cpuTemp } else { "N/A" }
        BatteryStatus = $batteryStatus
    }
}

Function Update-Metrics {
    $metrics = Get-PerformanceMetrics

    $SystemNameText.Text = "System Name: $($metrics.SystemName)"
    $OSText.Text = "Operating System: $($metrics.OS)"
    $TotalMemoryText.Text = "Total Memory: $($metrics.TotalMemory)"
    $AvailableMemoryText.Text = "Available Memory: $($metrics.AvailableMemory)"
    $DiskUsageText.Text = "Disk Usage: $($metrics.DiskUsage)"
    $CPUUsageText.Text = "CPU Usage: $($metrics.CPUUsage)%"
    $CPUUsageBar.Value = $metrics.CPUUsage
    $MemoryUsageText.Text = "Memory Usage: $($metrics.MemoryUsage)%"
    $MemoryUsageBar.Value = $metrics.MemoryUsage
    $DiskIOText.Text = "Disk I/O: $($metrics.DiskIO) transfers/sec"
    $NetworkIOText.Text = "Network I/O: $($metrics.NetworkIO) bytes/sec"
    $NetworkInterfacesText.Text = "Network Interfaces: $($metrics.NetworkInterfaces)"
    $UptimeText.Text = "System Uptime: $($metrics.Uptime.Days) days, $($metrics.Uptime.Hours) hours"
    $CPUTemperatureText.Text = "CPU Temperature: $($metrics.CPUTemperature)"
    $BatteryStatusText.Text = "Battery Status: $($metrics.BatteryStatus)"
}

$timer = [System.Windows.Threading.DispatcherTimer]::new()
$timer.Interval = [TimeSpan]::FromSeconds(2)
$timer.Add_Tick({ Update-Metrics })
$timer.Start()

# Show the Window
$window.ShowDialog()
