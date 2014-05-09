#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	This file belongs in $home\Documents\WindowsPowerShell\
#	If stored as Microsoft.PowerShell_profile.ps1, applies to CurrentUser, CurrentHost
#	If stored as profile.ps1, applies to CurrentUser, AllHosts
#
#	See end of file for history
#----------------------------------------------------------------------------------------------------

### Add shared modules location
$sharedModulesPath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
if (test-path $sharedModulesPath) {
    $env:PSModulePath = "$sharedModulesPath;$env:PSModulePath"
}

### Add PowerShell Community Extensions
$pscxPath = "${Env:\ProgramFiles(x86)}\PowerShell Community Extensions\Pscx3\Pscx"
if (test-path $pscxPath) {
    Import-Module Pscx
}
else {
	"NOTE: PowerShell Community Extension (Pscx) 3.x was not found"
}
### Add USER's scripts dir to path
$userScriptPath = "$env:USERPROFILE\Documents\WindowsPowerShell"
if (test-path $userScriptPath) {
    $env:path += ";$userScriptPath"
}

### Add Git tools to path. NOTE: git\cmd should already be in path
$gitToolsRoot = (Get-Item "Env:ProgramFiles(x86)").Value + "\Git"
if (test-path $gitToolsRoot) {
    $env:path += ";$gitToolsRoot\bin"
    . Add-GitHelpers.ps1
}
# Load posh-git example profile
$poshgitDir = (Get-Item "Env:SystemDrive").Value + "\src\posh-git"
if (test-path $poshgitDir) {
	. "$env:SystemDrive\src\posh-git\profile.example.ps1"
}
else {
	# Check for posh-git in <systemdrive>:\src
	$poshgitDir = (Get-Item "Env:SystemDrive").Value + "\src\posh-git"
	if (test-path $poshgitDir) {
		. "$env:SystemDrive\src\posh-git\profile.example.ps1"
	}
}


### Add Visual Studio tools
$idePath = Get-VSIdePath.ps1
if ($idePath -and (test-path $idePath)) {
	$env:path += ";$idePath";
}
else {
	"NOTE: Visual Studio was not found"
}

### .NET Framework (for MSBuild, etc)
# Look for 64-bit first
$fxRoot = "${Env:SYSTEMROOT}\Microsoft.NET\Framework64\"
if ($false -eq (test-path $fxRoot -ErrorAction SilentlyContinue)) {
	$fxRoot = "${Env:SYSTEMROOT}\Microsoft.NET\Framework\"
	if ($false -eq (test-path $fxRoot -ErrorAction SilentlyContinue)) {
		$fxRoot = ""
	}
}

### Find most recent version of .NET Fx
$newestFxPath = ""
gci $fxRoot v?.* | ?{ $_.PSIsContainer } | %{
	if ($newestFxPath -lt $_.FullName) {
		$newestFxPath = $_.FullName
	}
}
if (0 -lt $newestFxPath.Length) {
	[string]::format('Found .NET Fx; Adding [{0}] to path...', $newestFxPath)
	$env:path += [string]::format(';{0}', $newestFxPath)
}
else {
	"NOTE: .NET Framework was not found"
}


### .NET SDK tools
$MSWinSdksPath = "${Env:ProgramFiles(x86)}\Microsoft SDKs\Windows"
if (test-path $MSWinSdksPath) {
	# Seems that MS installers ensure only one path has these tools
	gci $MSWinSdksPath 'NETFX 4.0 Tools' -recurse | %{
		$NetFxToolsPath = $_
	}

	if ($NetFxToolsPath.PSIsContainer) {
		[string]::format('Found .NET SDK Tools; Adding [{0}] to path...', $NetFxToolsPath.FullName)
		$env:path += [string]::format(';{0}', $NetFxToolsPath.FullName)
	}
	else {
		"NOTE: .NET SDK tools were not found"
	}
}
else {
	"NOTE: Path to Microsoft Windows SDKs was not found"
}


### Alias for amount of free disk space
if (test-path "$publicScriptPath\DiskFreeSpace.ps1") {
    set-alias df       DiskFreeSpace.ps1	-ErrorAction SilentlyContinue
}

### Alias for Notepad++
if (test-path "${Env:ProgramFiles(x86)}\Notepad++") {
	$env:path += ";${Env:ProgramFiles(x86)}\Notepad++";
    set-alias npp       notepad++.exe	-ErrorAction SilentlyContinue
}
else {
	"NOTE: Notepad++ was not found"
}

### Define shortcuts for push & pop if they don't exist
# (Preferably they're defined in profile.ps1 for AllUsersAllHosts
if ($null -eq (get-alias p -ErrorAction SilentlyContinue) ) {
	set-alias p			pushd
}
if ($null -eq (get-alias pp -ErrorAction SilentlyContinue) ) {
	set-alias pp		popd
}

if ($null -eq (get-alias ss -ErrorAction SilentlyContinue) ) {
	set-alias ss		Select-String
}

### Define shortcut for listing dirs only
# (Preferably they're defined in profile.ps1 for AllUsersAllHosts
function Get-ChildContainers { gci | ?{$_.PSIsContainer} }		#NOTE: ls -ad works, too
if ($null -eq (get-alias ld -ErrorAction SilentlyContinue) ) {
	set-alias ld		Get-ChildContainers		# list dirs
}


#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	11/18/2013	Improved algo for including most recent .NET Fx and .NET Fx Tools in path
#	09/22/13:	Changed approach to have each user's profile point to c:\src\powershell-scripts (
#				rather than try to redir through env:PUBLIC\Documents...)
#	05/07/13:	Improve error condition handling; output message for some unavailable items
#	04/01/13:	Added .NET SDK tools to path
#	01/14/13:	Add Notepad++ to path if it is installed
#				Removed path for <user>\Documents\Scripts; replaced by <user>\Documents\WindowsPowershell
#   08/15/12:   Added Git support via posh-git
#	05/14/12:	Added support for Pscx (PowerShell Community Extensions)
#----------------------------------------------------------------------------------------------------
