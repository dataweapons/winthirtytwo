#Connecting to Exchange Online and Azure Active Directory

#This first command will import the Azure Active Directory module into your PowerShell session.
Import-Module MSOnline

#Capture administrative credential for future connections.
$credential = get-credential

#Establishes Online Services connection to Azure Active Directory  
Connect-MsolService -Credential $credential

#Creates an Exchange Online session
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $credential -Authentication Basic -AllowRedirection

#Import session commands
Import-PSSession $ExchangeSession 
