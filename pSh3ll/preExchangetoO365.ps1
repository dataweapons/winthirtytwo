#https://technet.microsoft.com/library/mt130478.aspx
#https://support.office.com/en-us/article/Ways-to-migrate-multiple-email-accounts-to-Office-365-0a4913fe-60fb-498f-9155-a86516418842?ui=en-US&rs=en-US&ad=US

get-mailbox -ResultSize unlimited | ?{$_.recipienttypedetails -eq “RoomMailbox”} | get-calendarprocessing | select identity, bookinpolicy | export-csv roompolicies.csv –notype

Get-Mailbox -resultsize unlimited | Where {$_.ForwardingAddress -ne $null} | Select Name, PrimarySMTPAddress, ForwardingAddress, DeliverToMailboxAndForward | Export-Csv c:\export\ForwardingInfo.csv –NoTypeInformation
