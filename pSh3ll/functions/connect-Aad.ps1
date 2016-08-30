# Connecting to Azure Active Directory

#This first command will import the Azure Active Directory module into your PowerShell session.
Import-Module MSOnline

#Capture administrative credential for future connections.
$credential = get-credential

#Establishes Online Services connection to Azure Active Directory  
Connect-MsolService -Credential $credential
