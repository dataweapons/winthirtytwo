param(
[string]$user,
[string]$exch_server,
[string]$path
)

$fullpath = $path + "\" + $user + ".pst"
$full_exch_server_URI = "http://" + $exch_server + "/PowerShell"

Write-host "Opening Session to Exchange"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $full_exch_server_URI -Authentication Kerberos
Write-host "Starting Session..."
Import-PSSession $Session -AllowClobber
Write-Host "Create Export PST request for user $user to $fullpath"
New-MailboxExportRequest -Mailbox $user -FilePath $fullpath
Write-Host "Closing Session"
Remove-PSSession $Session
