# mkpkg-SonicWall_NX.ps1

$fqdnSslVpnd = 'magic.dataweapons.org'

$curDC = @LogonServer
$msiFile = 'NetExtender.7.0.196.msi'
$pathToMsi = 'Localdrive\path\to\deployable'
$pathToPki = 'CertEnroll\cert.cer'

$authDomain = 'dataweapons.org'
$privUsername = 'administrator'
$privPass = 'aaaaassdd'

$runcert = 'certutil -addstore TrustedPublisher "'&$curDC&'"\"'&$pathToPki&'"'
$runstring = 'msiexec.exe /i "'&$curDC&'"\"'&$msiFile&'" /quiet /lv!*x c:\netextender.log ALLUSERS=2'

$rtn = RunAsWait("'&$privUsername&'","'&$authDomain&'","'&$privPass&'",1,@ComSpec & " /c " & $runcert[, "c:\windows\temp")
$rtn = RunAsWait("'&$privUsername&'","'&$authDomain&'","'&$privPass&'",1,$runstring)
$runstring ='"c:\Program Files (x86)\SonicWAll\SSL-VPN\NetExtender\NECLI.exe" 'addprofile -s '&$fqdnSslVpnd&':4433 -u '&@UserName&' -d '&$authDomain&''
$rtn = RunWait(@ComSpec & " /c " & $runstring,"c:\windows\temp")
