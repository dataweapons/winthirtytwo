######################################################################################################
#                                                                                                    #
# Name:        Complete-Conversion.ps1                                                               #
#                                                                                                    #
# Version:     1.2                                                                                   #
#                                                                                                    #
# Description: Completes the conversion of a mailbox migration to Office 365 in situations where the #
#              on-premises mailbox object does not convert to a remote mailbox.                      #
#                                                                                                    #
# Author:      Joseph Palarchio                                                                      #
#                                                                                                    #
# Usage:       Additional information on the usage of this script can found at the following         #
#              blog post:  http://blogs.perficient.com/microsoft/?p=23527                            #
#                                                                                                    #
# Disclaimer:  This script is provided AS IS without any support. Please test in a lab environment   #
#              prior to production use.                                                              #
#                                                                                                    #
######################################################################################################

$user = $args[0]

Set-AdServerSettings -ViewEntireForest $True

$addresses = (Get-Mailbox $user).EmailAddresses
$upn = (Get-Mailbox $user).UserPrincipalName

foreach ($address in $addresses) {
  try {
    if ($address.SmtpAddress.IndexOf(".mail.onmicrosoft.com") -gt 0) {
      $target = "SMTP:"+$address.SmtpAddress
    }
  }
  catch {}
}

Get-ADUser -Filter 'UserPrincipalName -eq $upn' | Set-ADUser -Clear homeMDB, homeMTA, msExchHomeServerName -Replace @{msExchVersion="44220983382016";msExchRecipientDisplayType="-2147483642";msExchRecipientTypeDetails="2147483648";msExchRemoteRecipientType="4";targetAddress=$target}
