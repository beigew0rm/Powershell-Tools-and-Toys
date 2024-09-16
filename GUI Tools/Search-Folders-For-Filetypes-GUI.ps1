<#=============================== beigeworm's FileType Search and Copy GUI ====================================

SYNOPSIS
Starts a GUI window to select a folder, then search for every file with a selected filetype and output to respective named files in the root folder

USAGE
1. Run script to open GUI
2. Select filetypes to search for
3. Select 'Move' or 'Copy'
4. Click 'Organize Files'
5. Outputted files will be in the root folder of this script.

#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Hide the powershell console
$Import = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);';
add-type -name win -member $Import -namespace native;
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0);

# Browse button function
function Select-Folder {
    param([string]$Description="Select a folder")
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $Description
    [void]$folderBrowser.ShowDialog()
    return $folderBrowser.SelectedPath
}

# Custom output box
Function Add-OutputBoxLine{
    Param ($outfeed) 
    $OutputBox.AppendText("`r`n$outfeed")
    $OutputBox.Refresh()
    $OutputBox.ScrollToCaret()
}

# Create the main form
$form = New-Object Windows.Forms.Form
$form.Text = " BeigeTools | File Organizer"
$form.Size = New-Object Drawing.Size @(380, 500)
$form.StartPosition = "CenterScreen"
$form.Font = 'Microsoft Sans Serif,10,style=Bold'
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

# Create controls
$folderButton = New-Object Windows.Forms.Button
$folderButton.Text = "Browse Folder"
$folderButton.Location = New-Object Drawing.Point @(135, 175)
$folderButton.Size = New-Object Drawing.Size @(110, 30)
$form.Controls.Add($folderButton)

$processButton = New-Object Windows.Forms.Button
$processButton.Text = "Organize Files"
$processButton.Location = New-Object Drawing.Point @(250, 175)
$processButton.Size = New-Object Drawing.Size @(110, 30)
$form.Controls.Add($processButton)

$moveRadioButton = New-Object Windows.Forms.RadioButton
$moveRadioButton.Text = "Move"
$moveRadioButton.AutoSize = $true
$moveRadioButton.Location = New-Object Drawing.Point @(70, 180)
$form.Controls.Add($moveRadioButton)

$copyRadioButton = New-Object Windows.Forms.RadioButton
$copyRadioButton.Text = "Copy"
$copyRadioButton.Location = New-Object Drawing.Point @(10, 180)
$copyRadioButton.Checked = $true
$copyRadioButton.AutoSize = $true
$form.Controls.Add($copyRadioButton)

# Labels
$AudioLabel = New-Object Windows.Forms.Label
$AudioLabel.Text = "Audio Files"
$AudioLabel.Location = New-Object Drawing.Point @(10, 25)
$form.Controls.Add($AudioLabel)

$Videolabel = New-Object Windows.Forms.Label
$Videolabel.Text = "Video Files"
$Videolabel.Location = New-Object Drawing.Point @(130, 25)
$form.Controls.Add($Videolabel)

$ImageLabel = New-Object Windows.Forms.Label
$ImageLabel.Text = "Image Files"
$ImageLabel.Location = New-Object Drawing.Point @(250, 25)
$form.Controls.Add($ImageLabel)

# Text fields
$folderTextBox = New-Object System.Windows.Forms.TextBox
$folderTextBox.Location = New-Object System.Drawing.Point(10, 215)
$folderTextBox.BackColor = "#eeeeee"
$folderTextBox.Width = 350
$folderTextBox.Text = "C:\Path\To\Folder"
$folderTextBox.Multiline = $false
$folderTextBox.Font = 'Microsoft Sans Serif,10'
$form.Controls.Add($folderTextBox)

$OutputBox = New-Object System.Windows.Forms.TextBox 
$OutputBox.Multiline = $True;
$OutputBox.Location = New-Object System.Drawing.Point(10,250) 
$OutputBox.Width = 350
$OutputBox.Height = 200
$OutputBox.Scrollbars = "Vertical" 
$OutputBox.Font = 'Microsoft Sans Serif,8'
$form.Controls.Add($OutputBox)

$checkBoxes = @{}

# Audio checkboxes
$fileTypes = "mp3", "wav", "flac", "m4a"
$array = $fileTypes
$yPos = 50
foreach ($fileType in $fileTypes) {
    $checkBox = New-Object Windows.Forms.CheckBox
    $checkBox.Text = $fileType
    $checkBox.Location = New-Object Drawing.Point @(15, $yPos)
    $checkBox.Size = New-Object Drawing.Size @(70, 20)
    $form.Controls.Add($checkBox)
    $checkBoxes[$fileType] = $checkBox
    $yPos += 30
}

# Video checkboxes
$fileTypes = "mp4", "mov", "mpeg", "mkv"
$array+= $fileTypes
$yPos = 50
foreach ($fileType in $fileTypes) {
    $checkBox = New-Object Windows.Forms.CheckBox
    $checkBox.Text = $fileType
    $checkBox.Location = New-Object Drawing.Point @(135, $yPos)
    $checkBox.Size = New-Object Drawing.Size @(70, 20)
    $form.Controls.Add($checkBox)
    $checkBoxes[$fileType] = $checkBox
    $yPos += 30
}

# Images checkboxes
$fileTypes = "png", "jpg", "bmp", "ico"
$array+= $fileTypes
$yPos = 50
foreach ($fileType in $fileTypes) {
    $checkBox = New-Object Windows.Forms.CheckBox
    $checkBox.Text = $fileType
    $checkBox.Location = New-Object Drawing.Point @(255, $yPos)
    $checkBox.Size = New-Object Drawing.Size @(70, 20)
    $form.Controls.Add($checkBox)
    $checkBoxes[$fileType] = $checkBox
    $yPos += 30
}

# Create full array
$fileTypes = $array


# Add event handlers
# Select folder from window
$folderButton.Add_Click({
    $folderPath = Select-Folder
    if ($folderPath -ne "") {
        $folderTextBox.Text = $folderPath
    }
})

# Start main function
$processButton.Add_Click({

    # Setup params and test folder exists
    $folderPath = $folderTextBox.Text

    if (-not (Test-Path $folderPath)) {
        [System.Windows.Forms.MessageBox]::Show("Invalid folder path. Please select a valid folder.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $selectedFileTypes = $fileTypes | Where-Object { $checkBoxes[$_].Checked }
    $operation = if ($moveRadioButton.Checked) { 'M' } else { 'C' }
    # Create folders
    foreach ($fileType in $selectedFileTypes) {
    
        if($PSCommandPath.Length -eq 0){    
            $scriptPath = Split-Path -Parent $pwd.Path
        }
        else{
            $scriptPath = Split-Path -Parent $PSCommandPath
        }
            $folderPathForExtension = Join-Path $scriptPath $fileType
            New-Item -ItemType Directory -Path $folderPathForExtension -Force
    }
    sleep 1

    # Copy or move the selected files
    foreach ($fileType in $selectedFileTypes) {
        $files = Get-ChildItem -Path $folderPath -Recurse -Include "*.$fileType"

        foreach ($file in $files) {
            $destinationFolder = Join-Path $scriptPath $fileType

            if ($operation -eq 'M') {
                $ind = $file.FullName
                Move-Item $file.FullName -Destination $destinationFolder -Force
                Add-OutputBoxLine -Outfeed "Moved : $ind"
            } elseif ($operation -eq 'C') {
                $ind = $file.FullName
                Copy-Item $file.FullName -Destination $destinationFolder -Force
                Add-OutputBoxLine -Outfeed "Copied : $ind"
            }
            Add-OutputBoxLine -Outfeed "-----------------------------------------"
        }
    }

    # Operation complete pop-up
    [System.Windows.Forms.MessageBox]::Show("Operation Complete", "Operation Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})

# Display the form
$form.ShowDialog()
