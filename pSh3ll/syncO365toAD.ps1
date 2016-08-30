
Import-Module ActiveDirectory 
#Change CSV file to relfect the file you are importing from 
$Users = Import-Csv -Path "C:\.............\*FILENAME*.csv" 
foreach ($User in $Users) 
{ 
# UPDATE OU=******** to split users into groups for bulk attribute updating. 
$OU = "OU=NEW OU YOU CREATED" 
$Password = $User.password 
$Detailedname = $User.firstname + " " + $User.name 
$UserFirstname = $User.Firstname 
$Email = $User.Emailaddress 
$SMTP = $User.smtp 
$FirstLetterFirstname = $UserFirstname.substring(0,1) 
$SAM = $FirstLetterFirstname + $User.name 
New-ADUser -Name $Detailedname -SamAccountName $SAM -UserPrincipalName $SAM -DisplayName $Detailedname -GivenName $user.firstname -EmailAddress $Email -Surname $user.name -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path $OU 
}

#Searches for the new OU, then loops through each user to change their SMTP) 
$users = Get-ADUser -Filter * -SearchBase "OU=YOUR OU DIR" 
-Properties ProxyAddresses 
$SMTPhold = "SMTP:" 
$domain = "YOURDOMAIN" 
foreach($User in $Users) 
{ 
$user.ProxyAddresses = $SMTPhold + $user.SamAccountName + $domain 
Set-ADUser -instance $user 
}
