
$Result = @()
foreach($server in (gc .\servers.txt)){
$computer = [ADSI](”WinNT://” + $server + “,computer”)
$Group = $computer.psbase.children.find(”Administrators”)
function getAdmins
{$members = ($Group.psbase.invoke(”Members”) | %{$_.GetType().InvokeMember(”Adspath”, ‘GetProperty’, $null, $_, $null)}) -replace ('WinNT://DOMAIN/' + $server + '/'), '' -replace ('WinNT://DOMAIN/', 'DOMAIN\') -replace ('WinNT://', '')
$members}
$Result += Write-Output "SERVER: $server"
$Result += Write-Output ' '
$Result += ( getAdmins )
$Result += Write-Output '____________________________'
$Result += Write-Output ' '
}
$Result > d:\results.txt
Invoke-Item d:\results.txt
( REPLY )
