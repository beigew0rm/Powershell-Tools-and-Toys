<#
========================== Matrix Character Cascade in Powershell =================================

SYNOPSIS
Matrix Style Screensaver in Powershell.

USAGE
1. Run script
2. Press any key to close.

#>

$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate("Powershell.exe")
$wshell.SendKeys("{F11}")
class Glyph {
    [int]$LastPosition
    [int]$CurrentPosition
    [int]$Velocity
    [int]$Intensity
    [double]$IntensityChange
    [char]$Current
    [char]$Last 
    Glyph() {$this.Setup()}
    [void]Setup(){
        $this.CurrentPosition = $script:rand.Next(-$script:ScreenHeight,.6*$script:ScreenHeight)
        $this.Velocity = 1
        $this.Intensity=0
        $this.IntensityChange = ($script:rand.Next(1,10)/150)
        $this.Current=$script:PossibleGlyphs[$script:rand.Next($script:glyphCount+1)]
        $this.Last=$script:PossibleGlyphs[$script:rand.Next($script:glyphCount+1)]  
    }
    [void]Move(){
        $this.LastPosition=$this.CurrentPosition
        $this.Intensity+=[Math]::Floor(255*$this.IntensityChange)
        if ($this.Intensity -gt 255){$this.Intensity = 255}
        $this.CurrentPosition+=$this.Velocity
        $this.Last = $this.Current
        if ($this.Current -ne ' '){$this.Current=$script:PossibleGlyphs[$script:rand.Next($script:glyphCount+1)]}
        if ($this.CurrentPosition -gt $script:ScreenHeight -1){$this.Setup()}
    }
}
$script:rand = [System.Random]::new()
$script:ScreenWidth=$host.UI.RawUI.WindowSize.Width
$script:ScreenHeight=$host.UI.RawUI.WindowSize.Height
[char[]]$script:PossibleGlyphs="    ℤ⅀℥ⱥ℧ℭ+=!@#%^&*()<>{}[]<>~ｻｶﾎﾖｦﾛｯβαγπΣθΩΞφµ".ToCharArray()
$glyphCount = $script:PossibleGlyphs.Count
$script:e=[char]27 #escape
[Glyph[]]$AllGlyphs=[Glyph[]]::new($script:ScreenWidth)
for ($i=0;$i -lt $AllGlyphs.Count;$i++){$AllGlyphs[$i]=[Glyph]::new()}
[Console]::CursorVisible=$false
Write-Output "$e[38;5;16m$e[48;5;16m$e[H$e[Jm" -NoNewline
$stopwatch =[System.Diagnostics.Stopwatch]::StartNew()
while (-not [System.Console]::KeyAvailable){
    if ($stopwatch.Elapsed.TotalMilliseconds -gt 33.33){
        for ($i = 0; $i -lt $script:ScreenWidth;$i++){
            $AllGlyphs[$i].Move()
            if ($AllGlyphs[$i].CurrentPosition -ge 0){
                [Console]::CursorLeft=$i
                [Console]::CursorTop=[Math]::Floor($AllGlyphs[$i].CurrentPosition)
                [Console]::Write("$e[48;5;16m$e[38;5;15m$($AllGlyphs[$i].Current)")            
            }
            if ($AllGlyphs[$i].LastPosition -ge 0){
                [Console]::CursorLeft=$i
                [Console]::CursorTop=[Math]::Floor($AllGlyphs[$i].LastPosition)
                [Console]::Write("$e[48;5;16m$e[38;2;0;$($AllGlyphs[$i].Intensity);0m$($AllGlyphs[$i].Last)")
            }
        }$stopwatch.Restart()
    }
}
$null = [Console]::ReadKey($true)
