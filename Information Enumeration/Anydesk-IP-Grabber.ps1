<# ============================= ANYDESK IP GRABBER =================================

SYNOPSIS
This script collects any incoming connections from a running anydesk process on a windows machine.
(useful for scambaiting using anydesk connections)

USAGE
1. Run this script
2. open anydesk and give connection code to other user (scammer etc)
3. the other party's IP should be displayed without needing to accept the connection.

#>

# Save the grabbed IP's to temp folder
$save = 'y' 

# Function to get active connections for AnyDesk
function Get-AnydeskConnections {
    $anydeskProcesses = Get-WmiObject Win32_Process | Where-Object { $_.Name -like "*anydesk*" }
    $ips = @()

    foreach ($process in $anydeskProcesses) {
        try {
            $processConnections = Get-NetTCPConnection | Where-Object { 
                $_.OwningProcess -eq $process.ProcessId -and $_.State -in ('SynSent', 'Established')
            }
            foreach ($connection in $processConnections) {
                $remoteIp = $connection.RemoteAddress
                $remotePort = $connection.RemotePort

                if (-not $remoteIp.StartsWith('208.115.231.') -and $remotePort -ne 80) {
                    if (-not $ips -contains $remoteIp) {
                        $ips += $remoteIp
                    }
                }
            }
        }
        catch {
            Write-Host "Error: Process does not exist anymore."
        }
    }
    return $ips
}

# Function to get IP info from ip-api
function Get-IpInfo {
    param (
        [string]$ip
    )
    try {
        $response = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip"
        return @{
            IP = $ip
            Country = $response.country
            Region = $response.regionName
            City = $response.city
            ISP = $response.isp
        }
    }
    catch {
        return @{ Error = "Connection IP: $ip" }
    }
}

# Function to exit the script
function Try-Exit {
    exit
}

# Main function to monitor and display AnyDesk connections
$msg = "Waiting for Anydesk Connection requests... [CTRL+C to exit]"

while ($true) {
    try {
        $ips = Get-AnydeskConnections
        Clear-Host
        
        if ($ips.Count -gt 0) {
            foreach ($ip in $ips) {
                Write-Host "Connection Request Found:"
                $info = Get-IpInfo -ip $ip
                foreach ($key in $info.Keys) {
                    Write-Host "$key : $($info[$key])"
                    if($save -eq 'y'){
                        "$key : $($info[$key])" | Out-File -FilePath "$env:TMP\AnyDesk-IP-Grabber.log" -Append -Force
                    }
                }
            }
            break
        }
        else {
            Write-Host $msg
        }
    }
    catch {
        Write-Host "Error: $_"
    }
    Start-Sleep -Seconds 3
}


