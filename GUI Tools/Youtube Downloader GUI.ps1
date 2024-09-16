
#---------------------------------DRAW GUI WINDOW------------------------------------------- 

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$base64IconString = "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAMAAABHPGVmAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAGuelRYdFJhdyBwcm9maWxlIHR5cGUgaWNjAAA4y51TW47kIAz85xR7BOMnHCeBRJr7X2AMht5Ja0baWaRWOoVxlYtK+mgt/RlLSkkwFnLTpqTdCJgmpF0vY0NBNkYEKVLlQAC7xLdPgNz8efnhCkCWNCsZGXAXYhWG/1i3sw5FeQOdsL+U/XKlX9af6rKNNIgylIBJkw8GhhYj5T0ZNzN3CDZeGqwC11vcjoUfqx5bcjunjbHR/h544Be8cPuK37zx0Yj9ZkIqbqkIfuB7/If6NKQaao933BvsF9FM9N30fTFNRS8RWfv5WGaPTIybEg+KWwOMg8XTNILjuVHPio4aHwX7ep/zbsL0b4xb2CBkb6D3IqL4b+P6zbsbLhZXo2UxtygeioZalXVYV72s31Ba0yv6b0l9D6pnR4kIH+obx7v0K91jEcoErM4Z7l5h4ueR57MvJuozHs39eRcwPdI7YkHljoZU4TulyPUOyYUj5o123cNsxWqzwIpFoLsDmj0e+UvZdh5Vh1/eFw+LRl3qPEgRJzjkfOTr2QAO6pNI2M74oFqfjWqtx6YI6dLSJ0ED/WBCMkW0AAAACXBIWXMAAAsSAAALEgHS3X78AAAC+lBMVEVHcEwBAQESEhEBAQEBAgEMCwtJSEEuLikpKCUBAgEODg0QEA8CAgISEREZGRcDAwMCAgI8PDgODg0ODQwDAwIDAwMCAgIDAwMHBwcMDAsCAgIDAwMJCQgVFRMJCQgEBQQMCwsICAgEBAQBAQELCgoLCgoDAwMDAwMQDw4ICAgGBgYFBQUGBgUNDQwICAgIBwcDAwMFBQUFBQUNDQwIBwcODQ0DBAMFBgUDAwMHBwYHBwcFBAQEBAMMCwsFBAQLCgoFBAQEBAMEBAQHBgYFBAQIBwcDBAMNDQwGBQUJCAgHBwcBAgEGBQUGBgYCAgIODg0GBgYEBAMDAwMHBwcDAwMFBAUMDAsDAwILCgoEBAQLCwoFBgUDAwMODg0JCAgHBwcDAwMDAgMKCgkEAwMGBQUGBQUJCQgFBQU8PD0FBQUJCQgEBAQBAQEFBQUGBgYFBQUbGxsLCwoGEgkNDw0GFggDCAQHDwgUFBQJCQgKDwoSRhs6PDcHGwoKJw8LKRBFRUUIJg4uLi0JJQ0EGAcODg0MNBIINQ89U0ExMTEHHgsoKCgIEwoL/wAAAAALiiD///8BAAALiyALjCBgYmEBAgL9/f0DVhEHfRoLjCECBwNAWkQDCgQBBAHy8fIDEgYMhiAFFggDBQMLjSEKgB4Lgx8LiSAKXxfy8PEDDgUMeR4LiCAEHwgKaBoINxANcR0GMg0GBwYIKg0EKQoFJgsLfR4KYhkGHAoKaxoGLw0IQREHEQgIOhAIUxUEJAkKbxsHTxMFRhAKdRwLVxcGPg8KZRkIVhQFIQkKXRj39/cQah8ISxNKSkoLRBQDGgYWMxoKJA4HYRYMMhINPBQLTRbNy8w+V0ILSBUPfyLs6+wQEhEHchgOWRqwsLANUhgRPxgyQDRSVFIOKBITWx9dXl319fUGWRNtbW1kZWUSURwQdyHGxsYcHhz7+/v+/v4QhyQOYRwyMzIlJSVBXkXh4eF9fX2/v78wOjISLheTk5OcnJypqalGWUnY2Ni0tLSpkz9aAAAA7HRSTlMA/Qr0+SUBAwX7FAjnDwbU8QIcFsjv6uJGRezbNQ0tvjgxnv4XEdHLHzpUsIcraT/OuEkhfk72vNd4W6bGYpI9qEGbbGJS4CmhXln3rnDdS2WimVfAenuyI48ZyH9CgnXlqzOMToRvlf2qi8Tjc7a0/6310/r82G60zP0O4LDR+5687P6Z9eD+pof0/P///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////REMdpEAAA8aSURBVGje7Vp3VFtXmlcFIVNkuiQEWEb0anrvVWA6BgymuGADjuPUmczstMzutHM1V5q3G2mEUUFggSmmV4OxDQyOHWyzi9fxOGMnJHGSmTiZmd3Zes6+p6cuwfBHfM6eM/6O7af33r33d79yv/ZMILygF/S3RTZhTfXPHaSsU3EWvTg6Pk+QIgo4HEaKLQ5/niCkEADif/gFSIh+nijBlJffPf2uQpH4HBmJ/eHp06fffffnZ7yeG0Z61PcfP/7kq9Ovlu77Bg12v43JfRLx609Pf/UAOfNN7tzW0dYExSFecfqnJe6w2fubQtjv4MIjmXJC8KzIdCSk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"
$iconimageBytes = [Convert]::FromBase64String($base64IconString)
$ims = New-Object IO.MemoryStream($iconimageBytes, 0, $iconimageBytes.Length)
$ims.Write($iconimageBytes, 0, $iconimageBytes.Length);
$alkIcon = [System.Drawing.Image]::FromStream($ims, $true)

 #---------------------------------------------------------CLICK FUCTIONS----------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$youtubinglist = New-Object System.Windows.Forms.Form
$youtubinglist.ClientSize = '452,220'
$youtubinglist.Text = "YouTube, Soundcloud and Bandcamp Downloader"
$youtubinglist.BackColor = "#000000"
$youtubinglist.Opacity = 0.93
$youtubinglist.TopMost = $false
$youtubinglist.Icon = [System.Drawing.Icon]::FromHandle((new-object System.Drawing.Bitmap -argument $ims).GetHIcon())

$inthaboxtext = New-Object System.Windows.Forms.Label
$inthaboxtext.Text = "Input YouTube Video URL"
$inthaboxtext.ForeColor = "#bcbcbc"
$inthaboxtext.AutoSize = $true
$inthaboxtext.Width = 25
$inthaboxtext.Height = 10
$inthaboxtext.Location = New-Object System.Drawing.Point(15, 15)
$inthaboxtext.Font = 'Microsoft Sans Serif,8,style=Bold'

$dltheyt = New-Object System.Windows.Forms.Button
$dltheyt.Text = "Download"
$dltheyt.Width = 80
$dltheyt.Height = 25
$dltheyt.Location = New-Object System.Drawing.Point(350, 37)
$dltheyt.Font = 'Microsoft Sans Serif,8,style=Bold'
$dltheyt.BackColor = "#eeeeee"

$urltextline = New-Object System.Windows.Forms.TextBox
$urltextline.Location = New-Object System.Drawing.Point(15, 40)
$urltextline.BackColor = "#eeeeee"
$urltextline.Width = 300
$urltextline.Height = 40
$urltextline.Multiline = $false
$urltextline.Font = 'Microsoft Sans Serif,8,style=Bold'

$outputboxil = New-Object System.Windows.Forms.TextBox 
$outputboxil.Multiline = $True;
$outputboxil.Location = New-Object System.Drawing.Size(15,90) 
$outputboxil.Width = 420
$outputboxil.Height = 80
$outputboxil.Scrollbars = "Vertical" 
$outputboxil.Text = "Ready for URL. (Leave As `"%(title)s`" To Save With Video Title )
----------------------------------------------------------------------------------------        
   ( Can Be used with Bandcamp - *Remove* `"?action=download`" )"
$outputboxil.Font = 'Microsoft Sans Serif,8,style=Bold'

$mp3boxtext = New-Object System.Windows.Forms.Label
$mp3boxtext.Text = ".mp3"
$mp3boxtext.ForeColor = "#bcbcbc"
$mp3boxtext.AutoSize = $true
$mp3boxtext.Width = 25
$mp3boxtext.Height = 10
$mp3boxtext.Location = New-Object System.Drawing.Point(60, 67)
$mp3boxtext.Font = 'Microsoft Sans Serif,8,style=Bold'

$mp3box = New-Object System.Windows.Forms.CheckBox
$mp3box.Width = 20
$mp3box.Height = 20
$mp3box.Location = New-Object System.Drawing.Point(40, 65)

$wavboxtext = New-Object System.Windows.Forms.Label
$wavboxtext.Text = ".wav"
$wavboxtext.ForeColor = "#bcbcbc"
$wavboxtext.AutoSize = $true
$wavboxtext.Width = 25
$wavboxtext.Height = 10
$wavboxtext.Location = New-Object System.Drawing.Point(160, 67)
$wavboxtext.Font = 'Microsoft Sans Serif,8,style=Bold'

$wavbox= New-Object System.Windows.Forms.CheckBox
$wavbox.Width = 20
$wavbox.Height = 20
$wavbox.Location = New-Object System.Drawing.Point(140, 65)

$flacboxtext = New-Object System.Windows.Forms.Label
$flacboxtext.Text = ".flac"
$flacboxtext.ForeColor = "#bcbcbc"
$flacboxtext.AutoSize = $true
$flacboxtext.Width = 25
$flacboxtext.Height = 10
$flacboxtext.Location = New-Object System.Drawing.Point(260, 67)
$flacboxtext.Font = 'Microsoft Sans Serif,8,style=Bold'

$flacbox = New-Object System.Windows.Forms.CheckBox
$flacbox.Width = 20
$flacbox.Height = 20
$flacbox.Location = New-Object System.Drawing.Point(240, 65)

$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = New-Object System.Drawing.Point(17, 190)
$ProgressBar.Size = New-Object System.Drawing.Size(417, 20)
$ProgressBar.Style = "Continuous"



Function Add-utputBoxLine {
    Param ($utfeed) 
    $OutputBoxil.AppendText("`r`n$utfeed")
    $OutputBoxil.Refresh()
    $OutputBoxil.ScrollToCaret()
}

    $youtubinglist.controls.AddRange(@($inthaboxtext, $dltheyt, $urltextline, $mp3box, $wavbox, $flacbox, $flacboxtext, $wavboxtext, $mp3boxtext, $urlboxtext, $outputboxil, $ProgressBar))

$dltheyt.Add_Click({


    Add-utputBoxLine -utfeed "-------------------------------------------------------"


if($mp3box.Checked){
        $thesong = $urltextline.Text
        Add-utputBoxLine -utfeed "This window Will freeze until complete..."


        $saveytloc = New-Object System.Windows.Forms.SaveFileDialog
        $saveytloc.Title = "Save Location"
        $saveytloc.AddExtension = $true;
        $saveytloc.Filter = "MP3 Files (*.mp3)|*.mp3|All Files (*.*)|*.*"
        $saveytloc.AddExtension = $true; 
        $saveytloc.FileName = "%(title)s"

      if($saveytloc.ShowDialog() -eq 'OK')
        {
    
        $filetogo = $saveytloc.FileName
        New-Item -Path $env:temp\Domain.txt -ItemType File -Force
        New-Item -Path $env:temp\Users.txt -ItemType File -Force
        Add-Content $env:temp\Domain.txt $filetogo
        Add-Content $env:temp\Users.txt $thesong

Start-Job -ScriptBlock {
          
        $hjkbluycvvy = Get-Content $env:temp\Domain.txt
        $thesong = Get-Content $env:temp\Users.txt
        cd C:\Temp
        ./youtube-dl.exe -x -i -w --audio-format mp3 --abort-on-unavailable-fragment --audio-quality 0 -o "$hjkbluycvvy" $thesong
    
    } -Name Download-YT
        

        Add-utputBoxLine -utfeed "Done."
        Add-utputBoxLine -utfeed "--------------------------------------------------------"
        Add-utputBoxLine -utfeed "Ready.."
         
        }
     else{
        Add-utputBoxLine -utfeed "Cancelled."
        Add-utputBoxLine -utfeed "--------------------------------------------------------"
        Add-utputBoxLine -utfeed "Ready.."
        }

}
else{

}

if($wavbox.Checked){
        $thesong = $urltextline.Text
        Add-utputBoxLine -utfeed "This window Will freeze until complete..."

        $saveytloc = New-Object System.Windows.Forms.SaveFileDialog
        $saveytloc.Title = "Save Location"
        $saveytloc.AddExtension = $true;
        $saveytloc.Filter = "WAV Files (*.wav)|*.wav|All Files (*.*)|*.*"
        $saveytloc.AddExtension = $true; 
        $saveytloc.FileName = "%(title)s"
        
      if($saveytloc.ShowDialog() -eq 'OK')
        {
    
        $filetogo = $saveytloc.FileName
        New-Item -Path $env:temp\Domain.txt -ItemType File -Force
        New-Item -Path $env:temp\Users.txt -ItemType File -Force
        Add-Content $env:temp\Domain.txt $filetogo
        Add-Content $env:temp\Users.txt $thesong

Start-Job -ScriptBlock {
          
        $hjkbluycvvy = Get-Content $env:temp\Domain.txt
        $thesong = Get-Content $env:temp\Users.txt
        cd C:\Temp
        ./youtube-dl.exe -x -i -w --audio-format wav --abort-on-unavailable-fragment --audio-quality 0 -o "$hjkbluycvvy" $thesong
    
    } -Name Download-YT


        Add-utputBoxLine -utfeed "Done."
        Add-utputBoxLine -utfeed "--------------------------------------------------------"
        Add-utputBoxLine -utfeed "Ready.."
         
        }
     else{
        Add-utputBoxLine -utfeed "Cancelled."
        Add-utputBoxLine -utfeed "--------------------------------------------------------"
        Add-utputBoxLine -utfeed "Ready.."
        }

}
else{

}

if($flacbox.Checked){
        $thesong = $urltextline.Text
        Add-utputBoxLine -utfeed "This window Will freeze until complete..."


        $saveytloc = New-Object System.Windows.Forms.SaveFileDialog
        $saveytloc.Title = "Save Location"
        $saveytloc.AddExtension = $true;
        $saveytloc.Filter = "FLAC Files (*.flac)|*.flac|All Files (*.*)|*.*"
        $saveytloc.AddExtension = $true; 
        $saveytloc.FileName = "%(title)s"
    
    
      if($saveytloc.ShowDialog() -eq 'OK')
        {

        $filetogo = $saveytloc.FileName
        New-Item -Path $env:temp\Domain.txt -ItemType File -Force
        New-Item -Path $env:temp\Users.txt -ItemType File -Force
        Add-Content $env:temp\Domain.txt $filetogo
        Add-Content $env:temp\Users.txt $thesong

Start-Job -ScriptBlock {
          
        $hjkbluycvvy = Get-Content $env:temp\Domain.txt
        $thesong = Get-Content $env:temp\Users.txt
        cd C:\Temp
        ./youtube-dl.exe -x -i -w --audio-format flac --abort-on-unavailable-fragment --audio-quality 0 -o "$hjkbluycvvy" $thesong
    
    } -Name Download-YT
        

  
        Add-utputBoxLine -utfeed "Done."
        Add-utputBoxLine -utfeed "--------------------------------------------------------"
        Add-utputBoxLine -utfeed "Ready.."
         
        }
     else{
        Add-utputBoxLine -utfeed "Cancelled."
        Add-utputBoxLine -utfeed "--------------------------------------------------------"
        Add-utputBoxLine -utfeed "Ready.."
        }

}
else{

}


$x = 0

While((Get-Job -Name "Download-YT").State -eq "Running") {

    $bhkjlyjublby = $ProgressBar.Value
  #  Get-Job -Name "Download-YT"| Write-Progress $bhkjlyjublby
     Write-Progress -OutVariable $bhkjlyjublby -Activity "Downloading File..." -PercentComplete $x
     If($x -eq 100){
          $x = 1
     }
    Else{
         $x += 1
    }
}

Write-Progress -Activity "Downloading File..." -Completed

Get-Job -Name "Download-YT" | Remove-Job

 
})

#----------------------------------------------------------------FORM SETUP & NOTIFY----------------------------------------------------------------------------       
$dependenciesyt = New-Object System.Windows.Forms.Form
$dependenciesyt.ClientSize = '350,150'
$dependenciesyt.Text = "Install Dependencies"
$dependenciesyt.BackColor = "#000000"
$dependenciesyt.Opacity = 0.93
$dependenciesyt.TopMost = $false
$dependenciesyt.Icon = [System.Drawing.Icon]::FromHandle((new-object System.Drawing.Bitmap -argument $ims).GetHIcon())

$ytinstall = New-Object System.Windows.Forms.Button
$ytinstall.Text = "Install Dependencies"
$ytinstall.Width =  150
$ytinstall.Height = 25
$ytinstall.Location = New-Object System.Drawing.Point(15, 15)
$ytinstall.Font = 'Microsoft Sans Serif,8'
$ytinstall.BackColor = "#eeeeee"

$ytdoneit = New-Object System.Windows.Forms.Button
$ytdoneit.Text = "Check"
$ytdoneit.Width =  150
$ytdoneit.Height = 25
$ytdoneit.Location = New-Object System.Drawing.Point(185, 15)
$ytdoneit.Font = 'Microsoft Sans Serif,8'
$ytdoneit.BackColor = "#eeeeee"

$outputboxyt = New-Object System.Windows.Forms.TextBox 
$outputboxyt.Multiline = $True;
$outputboxyt.Location = New-Object System.Drawing.Size(15,50) 
$outputboxyt.Width = 320
$outputboxyt.Height = 80
$outputboxyt.Scrollbars = "Vertical" 
$outputboxyt.Text = "Installing Dependencies is only needed on first run"
$outputboxyt.Font = 'Microsoft Sans Serif,8,style=Bold'

$dependenciesyt.controls.AddRange(@($ytinstall, $ytdoneit, $OutputBoxyt))

Function Add-putBoxLine {
    Param ($outfeed) 
    $OutputBoxyt.AppendText("`r`n$outfeed")
    $OutputBoxyt.Refresh()
    $OutputBoxyt.ScrollToCaret()
}

$ytinstall.Add_Click({

Add-putBoxLine -outfeed "-------------------------------"
Add-putBoxLine -outfeed "This window will freeze
until downloads are complete"
Add-putBoxLine -outfeed "-------------------------------"

$Monytdep = "$env:temp\ffmpeg.exe"

    If (Test-Path $Monytdep){       
}
    Else{
        Add-putBoxLine -outfeed "Downloading ffmpeg.exe"
        $Pathe = (Get-Location)
        $urlffmpeg = "https://cdn.discordapp.com/attachments/803285521908236328/1089995848223555764/ffmpeg.exe"
        $outpathffmpeg = "$env:temp\ffmpeg.exe"
        i`wr -Uri $urlffmpeg -OutFile $outpathffmpeg
        Add-putBoxLine -outfeed "Done."
}


$Monytdep2 = "$env:temp\youtube-dl.exe"

    If (Test-Path $Monytdep2){       
}
    Else{
        Add-putBoxLine -outfeed "Downloading youtube-dl.exe"
        $urlytdl = "https://cdn.discordapp.com/attachments/803285521908236328/1089995848622030848/youtube-dl.exe"
        $outpathytdl = "$env:temp\youtube-dl.exe"
        i`wr -Uri $urlytdl -OutFile $outpathytdl
        Add-putBoxLine -outfeed "Done."
}

        
        Add-putBoxLine -outfeed "-------------------------------"
        Add-putBoxLine -outfeed "Ready...."
})

$ytdoneit.Add_Click({

$Monytdep = "$env:temp\ffmpeg.exe"
$Monytdep2 = "$env:temp\youtube-dl.exe"


    If (Test-Path $Monytdep){
       
       if(Test-Path $Monytdep2){
                Add-putBoxLine -outfeed "-------------------------------"
                Add-putBoxLine -outfeed "Installed!! - Close this window to start MonTools.exe"
       }
       else{
                Add-putBoxLine -outfeed "-------------------------------"
                Add-putBoxLine -outfeed "Dependencies not installed..."
       }

}
    Else{
       
                Add-putBoxLine -outfeed "-------------------------------"
                Add-putBoxLine -outfeed "Dependencies not installed..."
       }



})


$Monytdepend = "$env:temp\ffmpeg.exe"
$Monytdepend2 = "$env:temp\youtube-dl.exe"

Remove-Item $Monytdepend3 -Force

	        $Monytdepend = "$env:temp\ffmpeg.exe"
            $Monytdepend2 = "$env:temp\youtube-dl.exe"

        If (Test-Path $Monytdepend){

            if(Test-Path $Monytdepend2){
           
            }
            else{
            [void]$dependenciesyt.ShowDialog()
            }
}
else{
[void]$dependenciesyt.ShowDialog()
}
[void]$youtubinglist.ShowDialog()
