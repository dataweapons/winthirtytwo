On Error Resume Next

Const ForReading = 1
strPass = "PASSWORDGOESHERE"

Set objArgs = WScript.Arguments
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(objArgs(0), ForReading)
	strComputers = objFile.ReadAll
	objFile.Close
	arrComputers = Split(strComputers, vbCrLf)
	
	For Each strComputer In arrComputers
		Set objShell = CreateObject("Wscript.Shell")
		Set objScriptExec = objShell.Exec("ping -n 2 -w 1000 " & strComputer)
		Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
			If InStr(objScriptExec.StdOut.ReadAll, "Reply") > 0 Then  
				Err.Clear
				Set objUser = GetObject("WinNT://" & strComputer & "/Administrator, user")
			
				If Err.Number Then
		     		WScript.Echo strComputer & ": Incorrect Username"
					Err.Clear
				Else
					objUser.SetPassword strPass
					objUser.SetInfo
					'WScript.Echo " " & strComputer & " - Password successfully changed"
				End If	
			Else
			WScript.Echo strComputer & " : Could not find host!"			
			End If
	Next
