<#
.SYNOPSIS
UpdateADEmailAddr will get a list of all users with email addresses from Office365 and update the Active Directory email field.  
.DESCRIPTION
The first action of this script will log you on to Office 365 using the admin credentials you provide.
The Second action of this script will get all active mailboxes and filter the results down to the username and primary email address.
The Third action will take those results and update active directory

Conference* and *schedule* were filtered out because these are accounts that were created in Office 365 and don't have AD accounts,
and the script will fail if those are attempted to be added.

.
.EXAMPLE
.\UpdateADEmailAddr.ps1
#>
$365FQDN=dataweapons.org
$365Cred=Get-Credential
Import-Module MSOnline
$365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $365Cred -Authentication Basic AllowRedirection

Import-PSSession $365Session

Connect-MsolService -Credential $365Cred

Get-Mailbox -ResultSize unlimited |
where {$_.PrimarySmtpAddress -like "*$365FQDN*" -and $_.alias -notlike "conference*" -and $_.alias -notlike "*schedule*"}|
Select alias,PrimarySmtpAddress|
ForEach-Object {Set-ADUser -Identity $_.alias -replace @{mail=$_.PrimarySmtpAddress}}
