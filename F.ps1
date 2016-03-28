$a = "<style>"
$a = $a + "BODY{background-color:#012456;}"
$a = $a + "H2{color:White;}"
$a = $a + "TABLE{border-width: 2px;border-style: solid;border-color:white;border-collapse: collapse;}"
$a = $a + "TH{border-width: 2px;padding: 10px;border-style: solid;border-color:white;color:#FFFFFF;}"
$a = $a + "TD{border-width: 2px;padding: 10px;border-style: solid;border-color: white;color:white}"
$a = $a + "</style>"

get-wmiobject win32_service -comp(Get-Content C:\servers.txt)  -filter "StartName Like '%Administrator%'" | 
Select-Object @{Expression={$_.systemName};Label = "Server Name"},@{Expression={$_.DisplayName};Label = "Service Name"} , 
@{Expression={$_.Name};Label = "Service"}, 
@{Expression= {$_.StartName};Label = "Account"}, 
State |
ConvertTo-HTML -head $a -Body "<H2>Service Accounts Running As Domain Administrator</H2> " |
Out-File C:\ServerList.htm

Invoke-Expression C:\ServerList.htm
