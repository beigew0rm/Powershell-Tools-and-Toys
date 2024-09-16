function Get-RandomName {
    $adjectives = @('Green', 'Happy', 'Small', 'Big', 'Fast', 'Slow', 'Smart', 'Clever', 'Bright', 'Dark',
                    'Brave', 'Calm', 'Crazy', 'Fierce', 'Gentle', 'Loud', 'Nimble', 'Shiny', 'Silly', 'Tiny',
                    'Wild', 'Witty', 'Zealous', 'Adorable', 'Artistic', 'Charming', 'Cozy', 'Daring', 'Eager')
    $nouns = @('Dog', 'Cat', 'Bird', 'Car', 'House', 'Tree', 'Book', 'Chair', 'Lamp', 'Table',
               'Moon', 'Sun', 'Star', 'Ocean', 'River', 'Mountain', 'Bridge', 'Road', 'Castle', 'Robot',
               'Cookie', 'Cake', 'Cup', 'Guitar', 'Pencil', 'Sword', 'Shield', 'Shield', 'Rainbow', 'Flower')

    $randomAdjective = Get-Random -InputObject $adjectives
    $randomNoun = Get-Random -InputObject $nouns

    return "$randomAdjective-$randomNoun"
}

function Get-RandomFileExtension {
    $fileExtensions = @('.txt', '.docx', '.xlsx', '.pptx', '.pdf', '.jpg', '.png', '.mp3', '.mp4', '.zip')
    return Get-Random -InputObject $fileExtensions
}

# Set the root folder name
$rootFolderName = (Get-RandomName)

# Create the root folder
New-Item -ItemType Directory -Path $rootFolderName -Force | Out-Null

# Create 20 subfolders
for ($i = 1; $i -le 20; $i++) {
    $subFolderName = Join-Path -Path $rootFolderName -ChildPath (Get-RandomName)
    New-Item -ItemType Directory -Path $subFolderName -Force | Out-Null
    $words = Get-RandomName
    $index = 0
    while($index -lt 100){$words+= Get-RandomName;$words+= "`n";$index++}
    $fileCount = Get-Random -Minimum 10 -Maximum 101
    for ($j = 1; $j -le $fileCount; $j++) {
        $fileName = Join-Path -Path $subFolderName -ChildPath ((Get-RandomName) + (Get-RandomFileExtension))
        New-Item -ItemType File -Path $fileName -Force | Out-Null
        $words | Out-File -FilePath $fileName -Encoding utf8 -Append
    }
}

Write-Host "Random folders and files have been created successfully."
