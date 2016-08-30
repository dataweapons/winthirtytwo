function Connect-ExchangeOnline {
	param(
		$creds
	)
	if ($creds -eq $false) {$creds = Get-Credential}
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange '
             -ConnectionUri https://outlook.office365.com/powershell-liveid/ '
             -Credential $creds -Authentication Basic -AllowRedirection
	Import-PSSession $Session
}
