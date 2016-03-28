get-childitem cert:\. -recurse -codesigningcert
$Path=Read-Host -prompt "Enter the full path to the script to sign (\\Severname\Foldername\SomeScript.PS1)"
Set-AuthenticodeSignature -Filepath $path -Cert $cert

https://community.spiceworks.com/scripts/show_download/3157
https://community.spiceworks.com/scripts/show_download/2583-java-7-update-55-pdq-deployment-scripts
