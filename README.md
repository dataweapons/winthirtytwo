NOTE: for ballerz yo.

## [00] INSTALL
### Install service bus locally.
* [Installing and Configuring Service Bus for Windows Server] (https://msdn.microsoft.com/en-us/library/azure/jj193014(v=azure.10).aspx)
* click [here] (http://go.microsoft.com/fwlink/?LinkID=252361).
```css
# Run in Service Bus PowerShell Console

# Create new SB Farm
$SBCertificateAutoGenerationKey = ConvertTo-SecureString -AsPlainText -Force -String "A strong auto generation key"

New-SBFarm -SBFarmDBConnectionString 'Data Source=localhost;Initial Catalog=SbManagementDB;Integrated Security=True' -InternalPortRangeStart 9000 -HttpsPort 9355 -TcpPort 9354 -MessageBrokerPort 9356 -RunAsName 'userName@domain' -AdminGroup 'BUILTIN\Administrators' -GatewayDBConnectionString 'Data Source=localhost;Initial Catalog=SbGatewayDatabase;Integrated Security=True' -CertificateAutoGenerationKey $SBCertificateAutoGenerationKey -MessageContainerDBConnectionString 'Data Source=localhost;Initial Catalog=ServiceBusDefaultContainer;Integrated Security=True';


# Add SB Host
$SBRunAsPassword = ConvertTo-SecureString -AsPlainText -Force -String ***** Replace with RunAs Password for Service Bus in single quote ******;

Add-SBHost -SBFarmDBConnectionString 'Data Source=localhost;Initial Catalog=SbManagementDB;Integrated Security=True' -RunAsPassword $SBRunAsPassword -EnableFirewallRules $true -CertificateAutoGenerationKey $SBCertificateAutoGenerationKey;

# Create new SB Namespace
New-SBNamespace -Name 'ServiceBusDefaultNamespace' -AddressingScheme 'Path' -ManageUsers 'userName@domain';

# Get SB Client Configuration
$SBClientConfiguration = Get-SBClientConfiguration -Namespaces 'ServiceBusDefaultNamespace';

```
### install Azure CLI from [here] (http://aka.ms/webpi-azure-cli)

### install Azure Powershell [here] (http://aka.ms/webpi-azps) or :arrow_right:
### setup azure :arrow_heading_down:
```css
# Install the Azure Resource Manager modules from the PowerShell Gallery
Install-Module AzureRM

# Install the Azure Service Management module from the PowerShell Gallery
Install-Module Azure

# To make sure the Azure PowerShell module is available after you install
Get-Module –ListAvailable 

# To login to Azure Resource Manager
Login-AzureRmAccount

# You can also use a specific Tenant if you would like a faster login experience
# Login-AzureRmAccount -TenantId xxxx

# To view all subscriptions for your account
Get-AzureRmSubscription

# To select a default subscription for your current session
Get-AzureRmSubscription –SubscriptionName “your sub” | Select-AzureRmSubscription

# View your current Azure PowerShell session context
# This session state is only applicable to the current session and will not affect other sessions
Get-AzureRmContext

# To select the default storage context for your current session
Set-AzureRmCurrentStorageAccount –ResourceGroupName “your resource group” –StorageAccountName “your storage account name”

# View your current Azure PowerShell session context
# Note: the CurrentStorageAccount is now set in your session context
Get-AzureRmContext

# To list all of the blobs in all of your containers in all of your accounts
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
```
## [01] SETUP

### configure office365.
* start [here] (https://support.office.com/en-us/article/Add-users-and-domain-to-Office-365-6383f56d-3d09-4dcb-9b41-b5f5a5efd611?CorrelationId=f96b8eb8-166b-4be2-90eb-e9138b03c1f5&ui=en-US&rs=en-US&ad=US)
* do this :arrow_heading_down:
```css
$dom = "<domain.name>"

set-msoldomain -name $dom -IsDefault
set-MsolDomainAuthentication -Authentication Managed -DomainName $dom

#The following commands convert the existing domain to use single sign-on. Notice the certificate is in Base-64 encoding:
convert-MsolDomainToFederated

$brand = "brand Ltd."
$ActiveSO = "https://adfs.$dom/adfs/services/trust/2005/usernamemixed"
$PLUri$ = "https://adfs.$dom/adfs/ls"
$IssuerUri = "https://adfs.$dom/adfs/services/trust"
$cert = "MIIEQzCCAyugAwIBAgIKYQm1CwAAAAAAEDANBgkqhkiG9w0BAQUFADBIMRMwEQYK
CZImiZPyLGQBGRYDY29tMR0wGwYKCZImiZPyLGQBGRYNd29vZGdyb3ZlYmFuazES
MBAGA1UEAxMJRGVudmVyLUNBMB4XDTEwMDExMDA2NDEwMFoXDTExMTExMTAxMTM0
MFowIzEhMB8GA1UEAxMYZGVudmVyLndvb2Rncm92ZWJhbmsuY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApUaiuxFkfXf9O5kUSpxOBSBFhjFirBb3
ddcs2weW/4cMniVNYGanLABVuqltfRHqWz6WZF/98VbqfCaETBaKu/QggcuhMoBc
yT7E4n35GOFxf8OVUy38VI1BrFon/crs8IUc0pK3qKG0n4rsCRwnpxoEPar0MiSP
r8jpDZa/eLcMV/1lFifpNXz2v1wKWYRKXrvg1sLJyABSRoAZShxaMcXehS0egmiP
gYNhvZln2Z/M2Xwy5oh21lAjzbrW2eLmsqr1OTsFO497CBsuoWS4KQUbxf7hVj3T
tgPXTphJsg6+2606nlJqflsxjpH90ucendRZVPJ1Vs83yMUcPUyA+QIDAQABo4IB
UjCCAU4wDgYDVR0PAQH/BAQDAgWgMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcV
CIP16AeH74RRh62DOIaW7CWEl7BNJ4bS92uFwqxxAgFkAgECMB0GA1UdDgQWBBQ6
RGMSiX+JPfV4zEGxeXGeFXm1kzAfBgNVHSMEGDAWgBSZzCX7ueHUBH7PY6wVldwn
N/ntwjA/BgNVHR8EODA2MDSgMqAwhi5odHRwOi8vcGtpLndvb2Rncm92ZWJhbmsu
Y29tL0NEUC9EZW52ZXItQ0EuY3JsMEoGCCsGAQUFBwEBBD4wPDA6BggrBgEFBQcw
AoYuaHR0cDovL3BraS53b29kZ3JvdmViYW5rLmNvbS9BSUEvRGVudmVyLUNBLmNy
dDATBgNVHSUEDDAKBggrBgEFBQcDATAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUF
BwMBMA0GCSqGSIb3DQEBBQUAA4IBAQCVaxdQ2nO5cpo0AQL+Pk/hXs3JOe+cRD1F
q4QZzAtef7viv4By6RI4xvbjap5iRs3wzWBuRdTT4zKcTZrUkBuyo3rxkmy8dzbh
0nXFrIS6onvPQDAxXLgz8b/YnlfnpCH1t/FoH6lqjmsiESYtfj43j8epDg91OhvQ
hirX2Q+27LBEvf9pmG/Nc7WXlm38UI1tpHw9lYqEOde2bxz7o2hgLcZg8ptJx4ci
PnB9VyrfTjPutLI4GqSuaMqrYxzjVplNkVMV3ZjJc2Jh8mLiaY7iPwRO3zPMs+Vn
hb32hqVF14uxWC4DNO5ccaqTKxUKH0LngEo9GItFhjxGlcg0fwI0"
Set-MsolDomainAuthentication –DomainName $dom -FederationBrandName $brand -Authentication Federated -PassiveLogOnUri $PLUri -SigningCertificate $cert -IssuerUri $IssuerUri -ActiveLogOnUri $ActiveSO -LogOffUri $PLUri

Set-MsolPasswordPolicy DomainName $dom -NotificationDays 14 -ValidityPeriod 60 
```
### Link domain to office365. :arrow_heading_down:
```css
SynchronizeUpnForManagedUsers-Enable $True
```
### Setup azure with on premises domain.
```css
$cred=Get-Credential
Connect-MsolService -Credential $cred
Login-AzureRmAccount -Credential $cred
Register-AzureADConnectHealthADDSAgent -Credentials $cred
Get-MsolFederationProperty -DomainName $dom | FL Source, TokenSigningCertificate
Update-MsolFederatedDomain
Get-ADFSCertificate –CertificateType token-signing
Update-ADFSCertificate –CertificateType token-signing
Set-MSOLAdfscontext -Computer <ADFS server>
Update-MSOLFederatedDomain –DomainName $dom
MSOLFederatedDomain -DomainName $dom -SupportMultipleDomain
New-MsolFederatedDomain –SupportMultipleDomain –DomainName $dom
```
### Support subdomains.
* Open AD FS Management
* Right click the Microsoft Online RP trust and choose Edit Claim rules
* Select the third claim rule, and replace with :arrow_heading_down:
```css
c:[Type == "http://schemas.xmlsoap.org/claims/UPN"] => issue(Type = "http://schemas.microsoft.com/ws/2008/06/identity/claims/issuerid", Value = regexreplace(c.Value, "^((.*)([.|@]))?(?<domain>[^.]*[.].*)$", "http://${domain}/adfs/services/trust/"));
```
