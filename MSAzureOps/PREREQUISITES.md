# MSAzureOPs: repository of the buildout used by ballers.

## [00]INSTALL

## Azure CLI

* http://aka.ms/webpi-azure-cli
* http://azuresdkscu.blob.core.windows.net/downloads04/azure-cli.0.10.3.msi

### Azure Powershell
* http://aka.ms/webpi-azps
* https://www.microsoft.com/web/handlers/webpi.ashx/getinstaller/WindowsAzurePowershellGet.3f.3f.3fnew.appids

## [01] SETUP

### configure office365.
* https://support.office.com/en-us/article/Add-users-and-domain-to-Office-365-6383f56d-3d09-4dcb-9b41-b5f5a5efd611?CorrelationId=f96b8eb8-166b-4be2-90eb-e9138b03c1f5&ui=en-US&rs=en-US&ad=US

### Link domain to office365.
* SynchronizeUpnForManagedUsers-Enable $True

### Setup azure with on premises domain.
* $cred=Get-Credential
* Connect-MsolService -Credential $cred
* Register-AzureADConnectHealthADDSAgent -Credentials $cred
* Get-MsolFederationProperty -DomainName <domain.name> | FL Source, TokenSigningCertificate
* Update-MsolFederatedDomain
* Get-ADFSCertificate –CertificateType token-signing
* Update-ADFSCertificate –CertificateType token-signing
* Set-MSOLAdfscontext -Computer <ADFS server>
* Update-MSOLFederatedDomain –DomainName <domain.name>
* MSOLFederatedDomain -DomainName <Federated Domain Name> -SupportMultipleDomain
* New-MsolFederatedDomain –SupportMultipleDomain –DomainName <Federated Domain Name>

### Support subdomains.
* Open AD FS Management
* Right click the Microsoft Online RP trust and choose Edit Claim rules
* Select the third claim rule, and replace with:
* ```css
c:[Type == "http://schemas.xmlsoap.org/claims/UPN"] => issue(Type = "http://schemas.microsoft.com/ws/2008/06/identity/claims/issuerid", Value = regexreplace(c.Value, "^((.*)([.|@]))?(?<domain>[^.]*[.].*)$", "http://${domain}/adfs/services/trust/"));
```
