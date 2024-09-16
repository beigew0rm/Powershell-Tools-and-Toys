
<#

========================= beigeworm's Gif Player ===========================

This Script downloads a GIF from Giphy and plays it in a GUI window.

USAGE
1. Run this script in powershell

#>
 

$url = "https://media3.giphy.com/media/tJqyalvo9ahykfykAj/giphy.gif?ep=v1_gifs_search" # example GIF (replace with your own link)
$gifPath = "$env:temp/g.gif"
iwr -Uri $url -OutFile $gifPath
$ErrorActionPreference = 'Stop'


    $form = New-Object System.Windows.Forms.Form
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $timer = New-Object System.Windows.Forms.Timer

    $form.Text = "GIF Player"
    $form.Size = New-Object System.Drawing.Size(490, 300)
    $form.StartPosition = 'CenterScreen'
    $form.Topmost = $true

    $pictureBox.Size = $form.Size
    $pictureBox.Image = [System.Drawing.Image]::FromFile($GifPath)

    $timer.Interval = 100  # Adjust the interval as needed for desired animation speed
    $timer.Add_Tick({
        $pictureBox.Image.SelectActiveFrame([System.Drawing.Imaging.FrameDimension]::Time, $timer.Tag)
        $pictureBox.Refresh()
        $timer.Tag = ($timer.Tag + 1) % $pictureBox.Image.GetFrameCount([System.Drawing.Imaging.FrameDimension]::Time)
    })

    $timer.Tag = 0

    $form.Controls.Add($pictureBox)

    $form.Add_Shown({ $timer.Start() })

    $form.ShowDialog()


sleep 5
Remove-Item $gifPath
