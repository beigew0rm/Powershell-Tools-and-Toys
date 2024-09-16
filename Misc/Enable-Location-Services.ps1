
function Enable-LocationServices {
    try {
        
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Value 1 -ErrorAction Stop
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Allow" -ErrorAction Stop
        Start-Service lfsvc -ErrorAction Stop

    } catch {
    }
}

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "Admin privileges needed for this script..." -ForegroundColor Red
    Write-Host "This script will self elevate to run as an Administrator and continue." -ForegroundColor DarkGray
    Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    exit
}
else{
    Enable-LocationServices
}
