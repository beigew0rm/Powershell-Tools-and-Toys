# Define the registry key and value for color filters
$registryKey = "HKCU:\Software\Microsoft\ColorFiltering"
$registryValue = "Active"
# $registryValue = "incative"
# Set the desired filter type
$desiredFilterType = 2  # Change this to the desired filter type (1: Grayscale, 2: Inverted, 3: Deuteranomaly, 4: Tritanomaly, 5: Colorblind)

# Enable color filters
New-Item -Path $registryKey -Force | Out-Null
Set-ItemProperty -Path $registryKey -Name $registryValue -Value $desiredFilterType

Write-Host "Color filter has been enabled."

# Send message to refresh the screen colors
$null = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::StringToHGlobalUni('SPI_SETDESKWALLPAPER'))