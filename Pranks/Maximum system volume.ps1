# ========================= SET SPEAKER VOLUME ===============================


Function Speaker($Volume){
    $wshShell = new-object -com wscript.shell;1..50 | % {$wshShell.SendKeys([char]174)}
    1..$Volume | % {$wshShell.SendKeys([char]175)}}

Speaker -Volume 50 # perameters ( 0 = 0% , 50 = 100% )
