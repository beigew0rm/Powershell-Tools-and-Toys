# Downgrade the default command prompt of Windows 11 to use Conhost again. Afterwards PowerShell can be used with paramters like "-WindowStyle Hidden" again.
# THIS IS PERMANENT UNTIL YOU REMOVE THESE KEYS FROM REGISTRY
$k = 'HKCU:\Console\%%Startup'
$v = '{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}'
Set-ItemProperty $k -N DelegationConsole -V $v
Set-ItemProperty $k -N DelegationTerminal -V $v
