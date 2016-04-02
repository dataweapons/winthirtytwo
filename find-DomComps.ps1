Import-Module "ActiveDirectory"

$deptWks = @("OU=Workstations,DC=zone0,DC=dataweapons,DC=org",
             "OU=Workstations,DC=zone0,DC=dataweapons,DC=org",
             "OU=Workstations,DC=zone0,DC=dataweapons,DC=org",
             "OU=Workstations,DC=zone0,DC=dataweapons,DC=org",
             "OU=Workstations,DC=zone0,DC=dataweapons,DC=org")

foreach ($deptWk in $deptWks) 
{ 
  ($objComputers += Get-ADComputer -SearchBase $deptWk -Filter *) 
}

$objComputers | Select name | Export-Csv -LiteralPath "C:\Temp\ComputerNames.txt" -NoTypeInformationA
