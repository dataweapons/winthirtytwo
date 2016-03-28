$curserver = @LogonServer
$pathToMsi = 'Localdrive\path\to\deployable'
$pathToPki = 'Localdrive\path\to\file.cer'
$authDomain = 'domain.local'
$privUsername = 'administrator'
$privPass = 'aaaaassdd'

$runcert = 'certutil -addstore TrustedPublisher "'&$curserver&'"\"'&$pathToPki&'"'
$runstring = 'msiexec.exe /i "'&$curserver&'NetExtender.7.0.196.msi" /quiet /lv!*x c:\netextender.log ALLUSERS=2'
$rtn = RunAsWait("<p'&$privUsername&'","<domain>","<password>",1,@ComSpec & " /c " & $runcert, "c:\windows\temp")
$rtn = RunAsWait("<administrator>","<domain>","<password>",1,$runstring)
$runstring ='"c:\Program Files (x86)\SonicWAll\SSL-VPN\NetExtender\NECLI.exe" '
 addprofile -s '&$fqdnSslVpnd&':4433 -u '&@UserName&' -d '&$authDomain&''
$rtn = RunWait(@ComSpec & " /c " & $runstring,"c:\windows\temp")
