$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# create user module path if necessary.
$modulePath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
    if(!(Test-Path $modulePath))
       {
           New-Item -Path $modulePath -ItemType Directory
       }

# load all script modules available to us
Get-Module -ListAvailable |
? { $_.ModuleType -eq "Script" } |
 Import-Module

# create profile if necessary.
$CUCHProfile = $PROFILE.CurrentUserCurrentHost
    if(!(Test-Path $CUCHProfile))
       {
           New-Item -Path $CUCHProfile -ItemType File
       }

$snapins = @(
    "Quest.ActiveRoles.ADManagement",
    "PowerGadgets",
    "VMware.VimAutomation.Core",
    "NetCmdlets"
)

$snapins | ForEach-Object { 
    if ( Get-PSSnapin -Registered $_ -ErrorAction SilentlyContinue )
       {
           Add-PSSnapin $_
       }
    }

# function loader 
Resolve-Path $here\functions\*.ps1 | 
? { -not ($_.ProviderPath.Contains(".Tests.")) } |
% { . $_.ProviderPath }

# inline functions, aliases and variables
function which($name) { Get-Command $name | Select-Object Definition }
function rm-rf($item) { Remove-Item $item -Recurse -Force }
function touch($file) { "" | Out-File $file -Encoding ASCII }
Set-Alias g gvim

$ScriptDir = "$here\scripts"
$UserBinDir = "$($env:UserProfile)\bin"
$SysBinDir = "D:\bin"

# PATH
# adds these to PATH.
$paths = @("$($env:Path)", $ScriptDir)
$paths = @("$($env:Path)", $UserBinDir)

# adds subdirs to PATH as well.
gci $SysBinDir | % { $paths += $_.FullName }
$env:Path = [String]::Join(";", $paths) 


Import-Module MSOnline 
$O365Cred = Get-Credential 
$O365Session = New-PSSession –ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection 
Import-PSSession $O365Session 
Connect-MsolService –Credential $O365Cred﻿
