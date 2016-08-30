# MSAzureOPs
repository of the buildout used by ballers.

## [00] INSTALL

### Azure CLI

* http://aka.ms/webpi-azure-cli
* http://azuresdkscu.blob.core.windows.net/downloads04/azure-cli.0.10.3.msi

### Azure Powershell
* http://aka.ms/webpi-azps
* https://www.microsoft.com/web/handlers/webpi.ashx/getinstaller/WindowsAzurePowershellGet.3f.3f.3fnew.appids

## [01] SETUP

### configure office365.
* https://support.office.com/en-us/article/Add-users-and-domain-to-Office-365-6383f56d-3d09-4dcb-9b41-b5f5a5efd611?CorrelationId=f96b8eb8-166b-4be2-90eb-e9138b03c1f5&ui=en-US&rs=en-US&ad=US
* set-msoldomain -name <domain.name> -IsDefault

* Set-MsolDomainAuthentication -Authentication Managed -DomainName <domain.name>

* The following commands convert the existing domain to use single sign-on. Notice the certificate is in Base-64 encoding:
* convert-MsolDomainToFederated
```css
$dom = "<domain.name>"
```
```css
$brand = "brand Ltd."
```
```css
$ActiveSO = "https://adfs.<domain.name>/adfs/services/trust/2005/usernamemixed"
```
```css
$PLUri$ = "https://adfs.<domain.name>/adfs/ls"
```
```css
$IssuerUri = "https://adfs.<domain.name>/adfs/services/trust"
```
```css
$cert = "MIIEQzCCAyugAwIBAgIKYQm1CwAAAAAAEDANBgkqhkiG9w0BAQUFADBIMRMwEQYK
CZImiZPyLGQBGRYDY29tMR0wGwYKCZImiZPyLGQBGRYNd29vZGdyb3ZlYmFuazES
MBAGA1UEAxMJRGVudmVyLUNBMB4XDTEwMDExMDA2NDEwMFoXDTExMTExMTAxMTM0
MFowIzEhMB8GA1UEAxMYZGVudmVyLndvb2Rncm92ZWJhbmsuY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApUaiuxFkfXf9O5kUSpxOBSBFhjFirBb3
UXJs2weW/4cMniVNYGanLABVuqltfRHqWz6WZF/98VbqfCaETBaKu/QggcuhMoBc
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
```

* Set-MsolDomainAuthentication –DomainName $dom -FederationBrandName $brand -Authentication Federated -PassiveLogOnUri $PLUri -SigningCertificate $cert -IssuerUri $IssuerUri -ActiveLogOnUri $ActiveSO -LogOffUri $PLUri

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
```css
c:[Type == "http://schemas.xmlsoap.org/claims/UPN"] => issue(Type = "http://schemas.microsoft.com/ws/2008/06/identity/claims/issuerid", Value = regexreplace(c.Value, "^((.*)([.|@]))?(?<domain>[^.]*[.].*)$", "http://${domain}/adfs/services/trust/"));
```
