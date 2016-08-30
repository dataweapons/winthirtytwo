# Filters for the IP, so only Interfaces that are actually in the net you want to modify are considered 
$strTargetNICAddress = "192.168.10.*" 
# IP of the new DNS Server, empty if none 
$strAddDNS = "192.168.10.45" 
# IP of the replaced DNS Server, empty if none 
$strRemoveDNS = "192.168.10.99" 
 
$ldapSearcher = new-object directoryservices.directorysearcher; 
$ldapSearcher.filter = "(objectclass=computer)"; 
$computers = $ldapSearcher.findall(); 
 
foreach ($computer in $computers) 
{ 
    $compname = $computer.properties["name"] 
    $ping = gwmi win32_pingstatus -f "Address = '$compname'" 
    if($ping.statuscode -eq 0) 
    {    
        $objWin32NAC = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -namespace "root\CIMV2" -computername $compname -Filter "IPEnabled = 'True'"  
        foreach ($objNACItem in $objWin32NAC)  
        {  
          Write-Host $compname ": " 
          Write-Host "Description:" $objNACItem.Description  
          Write-Host "DNSDomain:" $objNACItem.DNSDomain  
          Write-Host "DNSServerSearchOrder:" $objNACItem.DNSServerSearchOrder  
          Write-Host "Index:" $objNACItem.Index  
          Write-Host "IPAddress:" $objNACItem.IPAddress 
          Write-Host "MACAddress:" $objNACItem.MACAddress 
          if([string]$objNACItem.IPAddress -match $strTargetNICAddress) 
          { 
              Write-Host "The NIC matches the IP Net Filter: " ([string]$objNACItem.IPAddress -match $strTargetNICAddress) 
              if(!$objNACItem.DHCPEnabled) 
              { 
                   Write-Host("Network Card not supplied by DHCP, checking DNS entries...") 
                   $NewDNSString = $objNACItem.DNSServerSearchOrder 
                   if($strRemoveDNS.Length -gt 0) 
                   { 
                       if($NewDNSString -match $strRemoveDNS) 
                       { 
                            Write-Host("DNS Server entry to be removed found") 
                            $NewDNSString = ([string]($objNACItem.DNSServerSearchOrder -replace $strRemoveDNS)).Trim() 
                            while ($NewDNSString.Contains("  ")) 
                            { 
                                $NewDNSString = [string]($NewDNSString -replace "  "," ") 
                            } 
                            Write-Host "New DNS String: " $NewDNSString 
                        } 
                    } 
                    if($strAddDNS.Length -gt 0) 
                    { 
                        if($NewDNSString  -notmatch $strAddDNS) 
                        { 
                            Write-Host("DNS Server entry to be added found") 
                            $NewDNSString = [string]($NewDNSString + " " + $strAddDNS) 
                            while ($NewDNSString.Contains("  ")) 
                            { 
                                $NewDNSString = [string]($NewDNSString -replace "  "," ") 
                            } 
                            Write-Host "New DNS String: " $NewDNSString 
                        } 
                    } 
                $NewDNSEntries = $NewDNSString.Split(" ") 
                #The line below has the be uncommented for the script to actually apply the changes, else it just puts them out 
                #$objNACItem.SetDNSServerSearchOrder($NewDNSEntries) 
              } 
          }   
        } 
    } 
    else 
    { 
        Write-Host $compname ": Offline" 
    } 
    [console]::WriteLine()  
}
