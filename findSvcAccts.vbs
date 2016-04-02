' This script will enumerate services on all machines in a domain 
' to identify domain service accounts currently in use. 
' 
 
Const strDomainName = "CORP" 
 
Dim objComputer 
Dim objDomain 
Dim intPadding 
Dim intPadding2 
 
Set objDomain = GetObject("WinNT://" & strDomainName) 
 
objDomain.Filter = Array("Computer") 
 
For Each objComputer in objDomain 
  WScript.Echo "  " & objComputer.Name 
  objComputer.Filter = Array("service") 
 
  For Each objService in objComputer 
 
    If objService.ServiceAccountName<>"LocalSystem" _ 
      AND objService.ServiceAccountName<>"NT AUTHORITY\LocalService" _  
      AND objService.ServiceAccountName<>".\ASPNET" _  
      AND objService.ServiceAccountName<>".\NetShowServices" _  
      AND objService.ServiceAccountName<>"NT AUTHORITY\NetworkService" Then 
    intPadding = 42 - Len(objService.DisplayName) 
    intPadding2 = 32 - Len(objService.ServiceAccountName) 
    Wscript.Echo Space(4) & objService.DisplayName & Space(intPadding) & objService.ServiceAccountName 
    End If 
    Next 
Next 
 
 
