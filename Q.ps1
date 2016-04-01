Sometimes admins get lazy and configure service accounts to run as Administrator. It's simple and easy and almost always guaranteed to work. But of course that poses all kinds of issues. So here's a script that will query AD for any enabled computer systems, then query those systems for any services running as Administrator. I tried to organize it in Excel, and it works, but I just don't care for the output. Change it if you like. :)

Script

PowerShell
# This script will query all the computers in your domain for services configured   
# to run as Administrator, then outputs to Excel.  
#  
# To use this script you must install the RSAT tools on Windows Vista or 7  
# and enable the "Active Directory Module for Windows PowerShell" feature.  
#  
#  
# Created by Joshua Taylor  
# http://www.joshuastaylor.com  
  
import-module ActiveDirectory  
  
function get-ServiceAccountLogonAsAdmin {  
param ($strComputer)  
  
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()  
$domain = Get-ADDomain -Identity $domain.name  
$strAccount = $domain.name + "\administrator" 
  
Gwmi -computername $strComputer Win32_Service | Where-Object {$_.StartName -eq $strAccount}  
  
}  
 
$TimeStamp = Get-Date 
echo "This file contains systems that returned no matching services and any access errors." | out-file $env:temp\AdmSvcAcctChk.log -encoding ascii 
echo $TimeStamp | out-file $env:temp\AdmSvcAcctChk.log -append -encoding ascii 
  
# Get list of enabled computer accounts from AD  
$strComputers = Get-ADComputer -Filter 'Enabled -eq $True'  
  
# Create the workbook  
$xl = New-Object -comobject Excel.Application  
$xl.visible = $True  
$wb = $xl.Workbooks.Add()  
  
# Write headings for General  
$ws = $wb.Worksheets.Item(1)  
  
$ws.name = "Service Accounts"  
  
$ws.Cells.Item(1,1) = "System Name"  
$ws.Cells.Item(1,2) = "Service Name"  
$ws.Cells.Item(1,3) = "Account"  
$ws.Cells.Item(1,4) = "State"  
  
# Set the starting row  
$Row = 2  
  
# Loop through computers  
ForEach ($Computer in $strComputers) {  
        $ComputerName = $Computer.Name  
          
        # Clear any errors in $error  
        $Error.Clear()  
          
        $strServiceAccounts = Get-ServiceAccountLogonAsAdmin $Computer.Name | Select SystemName,Name,StartName,State  
          
        # Output custom message if the remote machine is inaccessible  
        $ErrorCode = $Error[0].Exception  
        switch -regex ($ErrorCode) {  
        ("The RPC server is unavailable") {  
        Write-warning "RPC Unavailable on $computerName"  
        echo "RPC Unavailable on $computerName" | out-file -filepath $env:Temp\AdmSvcAcctChk.log -encoding ascii -append 
        $obj += "" | Select @{e={$entry};n='Target'},@{e={"RPC_Unavalable"};n='caption'}   
        continue  
        }  
        ("Access denied") {   
        Write-warning "Access Denied on $computer"  
        echo "Access Denied on $computer" | out-file -filepath $env:Temp\AdmSvcAcctChk.log -encoding ascii -append 
        $obj += "" | Select @{e={$entry};n='Target'},@{e={"Access_Denied"};n='caption'}  
        continue  
        }  
        ("Access is denied") {  
        Write-warning "Access Denied on $computer"  
        echo "Access Denied on $computer" | out-file -filepath $env:Temp\AdmSvcAcctChk.log -encoding ascii -append 
        $obj += "" | Select @{e={$entry};n='Target'},@{e={"Access_Denied"};n='caption'}  
        continue  
        }  
        }  
  
        # check if any service accounts use the domain admin to logon  
        if ($strServiceAccounts.StartName -notlike "*administrator") {  
        echo "$ComputerName Returned Null"  
        echo "$ComputerName Returned Null" | out-file -filepath $env:Temp\AdmSvcAcctChk.log -encoding ascii -append} else {   
  
# Write to spreadsheet  
$ws = $wb.Worksheets.Item(1)  
  
  $ws.Cells.Item($Row, 1) = $strServiceAccounts.SystemName  
  $ws.Cells.Item($Row, 2) = $strServiceAccounts.Name  
  $ws.Cells.Item($Row, 3) = $strServiceAccounts.StartName  
  $ws.Cells.Item($Row, 4) = $strServiceAccounts.State  
  
# Increment Row  
$Row++  
}  
}  
 
Invoke-item $env:temp\AdmSvcAcctChk.log 
