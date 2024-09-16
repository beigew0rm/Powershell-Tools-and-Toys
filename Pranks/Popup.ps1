<# Arguments:
  message,timeout (in seconds),title, type (0x0 = 1 button, 0x1 = 2 buttons)

Additional information:
If u choose mode 0x0 (1 button)
if the timeout runs out, it will return -1 but if he clicks button (or closes window) it will return 1
If timeout is 0, it will stay forever
#> 
(New-Object -ComObject Wscript.Shell).Popup("Hello, this is a pop-up message",5,"Title",0x0)