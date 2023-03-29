
<#
==================== Mon's Simple Base64 to EXE converter =================================

SYNOPSIS
This Script will convert and run any base64 encoded string to a file of your choice (currently .exe)
the output file will be stored in the same path the script is run in.

USAGE
1. Use https://base64.guru/converter/encode/file to encode an EXE file.
2. Replace 'YOUR_BASE64_STRING_HERE' with your base64 string
3. Name the output file (.exe can be changed to your input executable extension)

#>



$b64 = 'YOUR_BASE64_STRING_HERE'
$decodedFile = [System.Convert]::FromBase64String($b64)
$File = "NAME_HERE"+".exe"
Set-Content -Path $File -Value $decodedFile -Encoding Byte
& $File