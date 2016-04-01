# a PowerShell script, licensed under GPL ;)
#
# importing dependancy, assuming it's already installed.
# Install RSAT for Windows workstation, AD DS role for Windows Server if missing
Import-Module "ActiveDirectory"

# an array containing the OU paths we'll enumerate
$OUpaths = @("OU=Allocated,OU=Workstations,OU=WDS Org,DC=wds,DC=wdsgroup,DC=local","OU=Available,OU=Workstations,OU=WDS Org,DC=wds,DC=wdsgroup,DC=local")

# loop though the array of OUs, adding the computers to a list ('Object' really)
foreach ($iOUpath in $OUpaths)
    {
        ($objComputers += Get-ADComputer -SearchBase $iOUpath -Filter *)    #You might need to refine the query witha 'Filter' depending on your AD structure
    }

# dump the list to a file
$objComputers | Select name | Export-Csv -LiteralPath "C:\Temp\ComputerNames.txt" -NoTypeInformationA
