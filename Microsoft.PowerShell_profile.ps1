#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	This file belongs in $home\Documents\WindowsPowerShell\
#	If stored as Microsoft.PowerShell_profile.ps1, applies to CurrentUser, CurrentHost
#	If stored as profile.ps1, applies to CurrentUser, AllHosts
#
#	See end of file for history
#----------------------------------------------------------------------------------------------------
<<<<<<< Updated upstream

=======
function Is-NetworkMappedDrive($path) {
	#TODO: detect if path is on net mapped drive
	# maybe use Win32_LogicalDisk where DriveType is 4?
	return $true
}
### If HOME is config'd to a network drive, set to local
# TODO: this doesn't seem to work on ASI network; restricted by policy?
# if (Is-NetworkMappedDrive($HOME)) {
	# Set-Variable HOMEDRIVE 'C:\' -Force
	# Set-Variable HOMEPATH "Users\$Env:UserName" -Force
	# Write-Host "Setting HOME to $HOMEDRIVE$HOMEPATH"
	# Set-Variable HOME "$HOMEDRIVE$HOMEPATH" -Force
	##Also set ~
	# (Get-PSProvider 'FileSystem').Home = "$HOMEDRIVE$HOMEPATH"
# }
### Add shared modules location
# 09/05/2014: removed b/c not using WindowsPowerShell\Modules anymore
#$sharedModulesPath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
#if (test-path $sharedModulesPath) {
#    $env:PSModulePath = "$sharedModulesPath;$env:PSModulePath"
#}
### Add PowerShell Community Extensions
$pscxPath = "${Env:\ProgramFiles(x86)}\PowerShell Community Extensions\Pscx3\Pscx"
if (test-path $pscxPath) {
    Import-Module $pscxPath\Pscx
}
else {
	Write-Warning "PowerShell Community Extension (Pscx) 3.x was not found"
}
### Add TFS SnapIn
$snapinName = 'Microsoft.TeamFoundation.PowerShell'
if ( (Get-PSSnapIn $snapinName -ErrorAction SilentlyContinue) -eq $null ) {
	# Try to add it
	Add-PSSnapIn $snapinName -ErrorAction SilentlyContinue
	# Was it successfully added?
	if ( (Get-PSSnapIn $snapinName -ErrorAction SilentlyContinue) -eq $null ) {
		Write-Warning "Failed to include SnapIn '$snapinName'.  Is it installed?"
	}
}
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream

### Load posh-git profile.
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}
# Load posh-git example profile (defines global prompt function)
. 'C:\tools\poshgit\dahlbyk-posh-git-fba883f\profile.example.ps1'
Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}

=======
# Load posh-git profile.  Check Tools dir first (where BoxStarter installs it)
$poshgitDir = (Get-Item "Env:SystemDrive").Value + "\tools\poshgit"
if (test-path $poshgitDir) {
	$poshgitScript = get-childitem $poshgitDir "profile.example.ps1" -recurse
	if ($poshgitScript ) {
		. $poshgitScript.FullName
	}
}
else {
	Write-Warning "Failed to load PoshGit."
}
>>>>>>> Stashed changes
### Add Visual Studio tools
$idePath = Get-VSIdePath.ps1
if ($idePath -and (test-path $idePath)) {
	$env:path += ";$idePath";
}
else {
	Write-Warning "Visual Studio was not found"
}
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
### Add Beyond Compare tools
$bc3ToolsRoot = (Get-Item "Env:ProgramFiles(x86)").Value + "\Beyond Compare 3"
if (test-path $bc3ToolsRoot) {
    $env:path += ";$bc3ToolsRoot"
    # Reset diff alias to use BC3
	Set-Alias diff 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe' -Force -Option AllScope
}
else {
	"NOTE: Beyond Compare 3 was not found"
}
<<<<<<< Updated upstream

### Add VS Code editor
$vscodeBin = (Get-Item "Env:ProgramFiles(x86)").Value + "\Microsoft VS Code"
if (test-path $vscodeBin) {
    $env:path += ";$vscodeBin"
}
else {
    "NOTE: VS Code was not found"
}

### Add GraphViz if it's installed
$graphViz = (Get-Item "Env:ProgramFiles(x86)").Value + "\GraphViz2.38"
if (test-path $graphViz) {
    $env:path += ";$graphViz\bin"
=======
### Add Sublime Text editor
$sublime3Bin = (Get-Item "Env:ProgramFiles").Value + "\Sublime Text 3"
if (test-path $sublime3Bin) {
    $env:path += ";$sublime3Bin"
>>>>>>> Stashed changes
}
else {
    "NOTE: GraphViz was not found"
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
	[string]::format('Found .NET Fx; adding [{0}] to path...', $newestFxPath)
	$env:path += [string]::format(';{0}', $newestFxPath)
}
else {
	Write-Warning ".NET Framework was not found"
}
<<<<<<< Updated upstream


### Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

### Define aliases & shortcuts
# Alias for amount of free disk space
if (test-path "$userScriptPath\DiskFreeSpace.ps1") {
    set-alias df       DiskFreeSpace.ps1	-ErrorAction SilentlyContinue
}
=======
### .NET SDK tools
$MSWinSdksPath = "${Env:ProgramFiles(x86)}\Microsoft SDKs\Windows"
if (test-path $MSWinSdksPath) {
	# Seems that MS installers ensure only one path has these tools
	gci $MSWinSdksPath 'NETFX 4.0 Tools' -recurse | %{
		$NetFxToolsPath = $_
	}
	if ($NetFxToolsPath.PSIsContainer) {
		[string]::format('Found .NET SDK Tools; adding [{0}] to path...', $NetFxToolsPath.FullName)
		$env:path += [string]::format(';{0}', $NetFxToolsPath.FullName)
	}
	else {
		Write-Warning ".NET SDK tools were not found"
	}
}
else {
	"NOTE: Path to Microsoft Windows SDKs was not found"
}


### .NET Version Manager ###
$DNVMPath = "${Env:ProgramFiles}\Microsoft DNX\DNVM"
if (test-path $DNVMPath) {
		[string]::format('Found .NET Version Manager; adding [{0}] to path...', $DNVMPath)
		$env:path += [string]::format(';{0}', $DNVMPath)
}
### Alias for amount of free disk space
if (test-path "$userScriptPath\DiskFreeSpace.ps1") {
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
>>>>>>> Stashed changes
### Define shortcuts for push & pop if they don't exist
# (Preferably they're defined in profile.ps1 for AllUsersAllHosts
if ($null -eq (get-alias p -ErrorAction SilentlyContinue) ) {
	set-alias p			pushd
}
if ($null -eq (get-alias pp -ErrorAction SilentlyContinue) ) {
	set-alias pp		popd
}
<<<<<<< Updated upstream
# Define shortcut for listing dirs only
=======
if ($null -eq (get-alias ss -ErrorAction SilentlyContinue) ) {
	set-alias ss		Select-String
}
### Define shortcut for listing dirs only
# (Preferably they're defined in profile.ps1 for AllUsersAllHosts
>>>>>>> Stashed changes
function Get-ChildContainers { gci | ?{$_.PSIsContainer} }		#NOTE: ls -ad works, too
if ($null -eq (get-alias ld -ErrorAction SilentlyContinue) ) {
	set-alias ld		Get-ChildContainers		# list dirs
}
#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	01/03/2017	Cleanup; removed unused functions & config settings: Is-NetworkMappedDrive, Sublime,
#				TFS PowerShell snapin, PowerShell Community Extensions, .NET SDK Tools
#	08/26/2016	Added Chocolatey, GraphViz support
#   04/05/2016  Added VS Code to path; removed Notepad++; removed ss in lieu of sls
#	12/04/2014	Include TFS Snapin; Fixed path for setting df alias; convert several messages
#				to use Write-Warning
#	09/05/2014	Use Beyond Compare 3 for diff; Fixed Pscx import problem; 
#				Removed use of shared modules location (archaic)
#	08/14/2014	Adapted to look for PoshGit where BoxStarter/Chocolatey installs it.
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
