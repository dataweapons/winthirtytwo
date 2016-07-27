setlocal
 
REM *********************************************************************
REM Environment customization begins here. Modify variables below.
REM *********************************************************************
 
REM Get ProductName from the Office product's core Setup.xml file, and then add "office15." as a prefix. 
set ProductName=Office15.PROPLUS
 
REM Set DeployServer to a network-accessible location containing the Office source files.
set DeployServer="\\SERVER\SHARE\Microsoft Office 2013 X86 2013\setup.exe"
 
REM Set LogLocation to a central directory to collect log files.
set LogLocation="\\SERVER\SHARE\Microsoft Office 2013 X86 2013\logfiles"
 
REM *********************************************************************
REM Deployment code begins here. Do not modify anything below this line.
REM *********************************************************************
 
IF NOT "%ProgramFiles(x86)%"=="" (goto ARP64) else (goto ARP86)
 
REM Operating system is X64. Check for 32 bit Office in emulated Wow6432 uninstall key
:ARP64
reg query HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432NODE\Microsoft\Windows\CurrentVersion\Uninstall\%ProductName%
if NOT %errorlevel%==1 (goto End)
 
REM Check for 32 and 64 bit versions of Office 2013 in regular uninstall key.(Office 64bit would also appear here on a 64bit OS) 
:ARP86
reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%ProductName%
if %errorlevel%==1 (goto Office) else (goto End)
 
REM If 1 returned, the product was not found. Run setup here.
:Office
%DeployServer%
 
echo %date% %time% Setup ended with error code %errorlevel%. &gt;&gt; %LogLocation%\%computername%.txt
 
REM If 0 or other was returned, the product was found or another error occurred. Do nothing.
:End
 
Endlocal
