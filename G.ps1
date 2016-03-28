Function GetCredentials {
	<#
	.SYNOPSIS
		Simple function to get and save domain credentials.
	.DESCRIPTION
		This function is meant to be used with any script where you need secure credentials.  
		The advantage of this function is it will save the credentials in a secure file that can
		be recalled later.  This will allow your script to use secure credentials without
		having to prompt for the password every time.
		
		The function will return a Powershell secure Credential object.
        
        Credit to Daniel for the idea of using a unique key value in the
        ConvertTo-SecureString cmdlet allowing multiple computers to use this
        credential file.
        LINK: http://poshcode.org/3752
        
        *** IMPORTANT ***
        Required:  Modify the $Key variable to get unique encryption on your
        credentials.
	.PARAMETER AuthUser
		Supply the username you want to use for authenticating.  By default your username
		will be used if nothing is supplied.
	.PARAMETER PathToCred
		Supply the path where you wish to store the credential files.  I recommend you update
		the default value to something that matches your environment.
	.EXAMPLE
		$Cred = GetCredentials
		
		This will use the default username of the user running the script, and the default
		location for the credentials.  If no credential file is given it will prompt the user
		for the username and password and save the password in a file at c:\utils.  
	.EXAMPLE
		$Cred = GetCredentials -AuthUser Administrator -PathToCred \\server\share\securefiles
		
		This call will check \\server\share\securefiles for the credential file for administrator,
		and if it exists return the proper Credential object.  If the file does not exist it will 
		prompt the user for the password and save the file.
	.OUTPUTS
		Object: System.Management.Automation.PsCredential
    .NOTES
        Author:            Martin Pugh
        Key Idea:          Daniel (http://poshcode.org/3752)
        Twitter:           @thesurlyadm1n
        Spiceworks:        Martin9700
        Blog:              www.thesurlyadmin.com
       
        Changelog:
           1.6          Updated function to save domain credentials domain\username
           1.5          Added user configurable encryption key, this will allow for using
                           the same credential file on multiple computers.
           1.0          Initial Release

	.LINK
		http://community.spiceworks.com/scripts/show/1629-get-secure-credentials-function
    .LINK
        http://poshcode.org/3752
	#>
Function Get-Credentials {
    Param (
	[String]$AuthUser = $env:USERNAME,
        [string]$PathToCred
    )
    $Key = [byte]29,36,18,74,72,75,85,52,73,44,0,21,98,76,99,28

    #Build the path to the credential file
    $CredFile = $AuthUser.Replace("\","~")
    $File = $PathToCred + "\Credentials-$CredFile.crd"
    #And find out if it's there, if not create it
    If (-not (Test-Path $File))
    {	(Get-Credential $AuthUser).Password | ConvertFrom-SecureString -Key $Key | Set-Content $File
    }
    #Load the credential file 
    $Password = Get-Content $File | ConvertTo-SecureString -Key $Key
    $AuthUser = (Split-Path $File -Leaf).Substring(12).Replace("~","\")
    $AuthUser = $AuthUser.Substring(0,$AuthUser.Length - 4)
    $Credential = New-Object System.Management.Automation.PsCredential($AuthUser,$Password)
    Return $Credential
}
