################### 
#Update DNS Forwarder  
#Created By Daniel OS 
#################### 
 
$computername = get-content "C:\dclist.txt" 
 
foreach ($computer in $computername)  
{ 
#These are the new forwarder IP addresses 
$arrFowarders = @("192.168.1.2","192.168.2.1") 
$objDNSServer = gwmi -Namespace "root\MicrosoftDNS" ` 
-Class MicrosoftDNS_server -ComputerName $computer 
$objDNSServer.Forwarders = $arrFowarders 
$output = $objDNSServer.put() 
Write-host "Configuration Complete." $computer 
 
}
