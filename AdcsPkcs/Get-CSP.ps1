function Get-CSP {
$signature = @"
[DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Auto)]
public static extern bool CryptEnumProviders(
    uint dwIndex,
    uint pdwReserved,
    uint dwFlags,
    ref uint pdwProvType,
    System.Text.StringBuilder pszProvName,
    ref uint pcbProvName
);
[DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Auto)]
public static extern bool CryptEnumProviderTypes(
    uint dwIndex,
    uint pdwReserved,
    uint dwFlags,
    ref uint pdwProvType,
    System.Text.StringBuilder pszTypeName,
    ref uint pcbTypeName
);
"@

    Add-Type -MemberDefinition $signature -Namespace PKI -Name CSP
    $CSP = "" | select Name, Type
    $ProvTypes = @{}
#region default value definition for provider types
    [UInt32]$dwIndex = 0
    [UInt32]$pdwProvType = 0
    $pszTypeName = New-Object Text.StringBuilder
    [UInt32]$pcbTypeName = 0
#endregion

    # retrieve provider type enumeration to a hashtable
    while ([PKI.CSP]::CryptEnumProviderTypes($dwIndex,0,0,[ref]$pdwProvType,$null,[ref]$pcbTypeName)) {
        $pszTypeName.Length = $pcbTypeName
        if ([PKI.CSP]::CryptEnumProviderTypes($dwIndex++,0,0,[ref]$pdwProvType,$pszTypeName,[ref]$pcbTypeName)) {
            $Type = $pszTypeName.TosTring()
            $ProvTypes.Add($pdwProvType,$Type)
        }
    }

#region default value definition for providers
    [UInt32]$dwIndex = 0
    [UInt32]$pdwProvType = 0
    $pszProvName = New-Object Text.Stringbuilder
    [UInt32]$pcbProvName = 0
#endregion
    
    # retrieve providers
    while ([PKI.CSP]::CryptEnumProviders($dwIndex,0,0,[ref]$pdwProvType,$null,[ref]$pcbProvName)) {
        $pszProvName.Length = $pcbProvName
        if ([PKI.CSP]::CryptEnumProviders($dwIndex++,0,0,[ref]$pdwProvType,$pszProvName,[ref]$pcbProvName)) {
            $CSP.Name = $pszProvName.ToString()
            $CSP.Type = $ProvTypes[$pdwProvType]
            $CSP
        }
    }
}
