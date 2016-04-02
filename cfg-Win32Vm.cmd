rem  Setting Default HKCU values by loading and modifying the default user registry hive
reg load "hku\temp" "%USERPROFILE%\..\Default User\NTUSER.DAT"
reg ADD "hku\temp\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /v SCRNSAVE.EXE /d "%windir%\system32\scrnsave.scr" /f
reg ADD "hku\temp\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /v ScreenSaveTimeOut /d "600" /f
reg ADD "hku\temp\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /v ScreenSaverIsSecure /d "1" /f
reg ADD "hku\temp\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /d " " /f
reg ADD "hku\temp\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache" /v Persistent /t REG_DWORD /d 0x0 /f
reg ADD "hku\temp\Software\Microsoft\Feeds" /v SyncStatus /t REG_DWORD /d 0x0 /f
reg ADD "hku\temp\Software\Microsoft\WIndows\CurrentVersion\Policies\Explorer" /v HideSCAHealth /t REG_DWORD /d 0x1 /f
reg unload "hku\temp"

rem Making modifications to the HKLM hive 
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v DisableFirstRunCustomize /t REG_DWORD /d 0x1 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0x0 /f
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0x1 /f
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /t REG_DWORD /d 0x1 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Disk" /v TimeOutValue /t REG_DWORD /d 200 /f
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Image" /v Revision /t REG_SZ /d 1.0 /f

reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Image" /v Virtual /t REG_SZ /d Yes /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Application" /v MaxSize /t REG_DWORD /d 0x100000 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Application" /v Retention /t REG_DWORD /d 0x0 /f
reg ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\System" /v MaxSize /t REG_DWORD /d 0x100000 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\System" /v Retention /t REG_DWORD /d 0x0 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" /v MaxSize /t REG_DWORD /d 0x100000 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" /v Retention /t REG_DWORD /d 0x0 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 0x0 /f
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer" /v NoRecycleFiles /t REG_DWORD /d 0x1 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0x0 /f
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0x0 /f
reg ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system" /v EnableLUA /t REG_DWORD /d 0x0 /f
reg Add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Sideshow" /v Disabled /t REG_DWORD /d 0x1 /f

rem Using Powershell to perform Windows Services modifications
Powershell Set-Service 'BDESVC' -startuptype "disabled"
Powershell Set-Service 'wbengine' -startuptype "disabled"
Powershell Set-Service 'DPS' -startuptype "disabled"
Powershell Set-Service 'UxSms' -startuptype "disabled"
Powershell Set-Service 'Defragsvc' -startuptype "disabled"
Powershell Set-Service 'HomeGroupListener' -startuptype "disabled"
Powershell Set-Service 'HomeGroupProvider' -startuptype "disabled"
Powershell Set-Service 'iphlpsvc' -startuptype "disabled"
Powershell Set-Service 'MSiSCSI' -startuptype "disabled"
Powershell Set-Service 'swprv' -startuptype "disabled"
Powershell Set-Service 'CscService' -startuptype "disabled"
Powershell Set-Service 'SstpSvc' -startuptype "disabled"
Powershell Set-Service 'wscsvc' -startuptype "disabled"
Powershell Set-Service 'SSDPSRV' -startuptype "disabled"
Powershell Set-Service 'SysMain' -startuptype "disabled"
Powershell Set-Service 'TabletInputService' -startuptype "disabled"
Powershell Set-Service 'Themes' -startuptype "disabled"
Powershell Set-Service 'upnphost' -startuptype "disabled"
Powershell Set-Service 'VSS' -startuptype "disabled"
Powershell Set-Service 'SDRSVC' -startuptype "disabled"
Powershell Set-Service 'WinDefend' -startuptype "disabled"
Powershell Set-Service 'WerSvc' -startuptype "disabled"
Powershell Set-Service 'MpsSvc' -startuptype "disabled"
Powershell Set-Service 'ehRecvr' -startuptype "disabled"
Powershell Set-Service 'ehSched' -startuptype "disabled"
Powershell Set-Service 'WSearch' -startuptype "disabled"
Powershell Set-Service 'wuauserv' -startuptype "disabled"
Powershell Set-Service 'Wlansvc' -startuptype "disabled"
Powershell Set-Service 'WwanSvc' -startuptype "disabled"

rem Making miscellaneous modifications
bcdedit /set BOOTUX disabled
vssadmin delete shadows /All /Quiet
Powershell disable-computerrestore -drive c:\
netsh advfirewall set allprofiles state off
powercfg -H OFF
net stop "sysmain"
fsutil behavior set DisableLastAccess 1

rem Making modifications to Scheduled Tasks
schtasks /change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable
schtasks /change /TN "\Microsoft\Windows\SystemRestore\SR" /Disable
schtasks /change /TN "\Microsoft\Windows\Registry\RegIdleBackup" /Disable
schtasks /change /TN "\Microsoft\Windows Defender\MPIdleTask" /Disable
schtasks /change /TN "\Microsoft\Windows Defender\MP Scheduled Scan" /Disable
schtasks /change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable
