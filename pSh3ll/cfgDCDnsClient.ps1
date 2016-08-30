$computer = get-content C:\computers.txt 
 
$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer | where {$_.IPEnabled -eq $true }  
Foreach($NIC in $NICs) {  
    $ip = ($NIC.IPAddress[0])  
    $dns = $NIC.DNSServerSearchOrder  
    $NIC.SetDNSServerSearchOrder($ip)  
    write-host $computer , $dns  
}
