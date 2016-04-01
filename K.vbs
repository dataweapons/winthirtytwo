On Error Resume Next 
Const ForReading = 1 
Set objDictionary = CreateObject("Scripting.Dictionary") 
Set objFSO = CreateObject("Scripting.FileSystemObject") 
Set objTextFile = objFSO.OpenTextFile("c:\scripts\computers.txt", ForReading) 
i = 0 
 
Do Until objTextFile.AtEndOfStream  
    strNextLine = objTextFile.Readline 
    objDictionary.Add i, strNextLine 
    i = i + 1 
Loop 
  
For Each objItem in objDictionary 
Set objComputer = GetObject("WinNT://" & objDictionary.Item(objItem) & "") 
objComputer.Filter = Array("User") 
    WScript.Echo "_______________________________________" 
    WScript.Echo "Computer: " & objDictionary.Item(objItem) 
    WScript.Echo "_______________________________________"  
For Each objUser in objComputer 
    Wscript.Echo objUser.Name & "(" & objUser.FullName & ")"  
Next 
    WScript.Echo "---------------------------------------" 
    WScript.Echo "Last Entry for:" & objDictionary.Item(objItem) 
    WScript.Echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
Next 
