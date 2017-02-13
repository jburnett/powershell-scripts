#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	This file belongs in $home\Documents\WindowsPowerShell\
#	If stored as Microsoft.PowerShell_profile.ps1, applies to CurrentUser, CurrentHost
#	If stored as profile.ps1, applies to CurrentUser, AllHosts
#
#	See end of file for history
#----------------------------------------------------------------------------------------------------

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

### Load posh-git profile.
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}
# Load posh-git example profile (defines global prompt function)
. 'C:\tools\poshgit\dahlbyk-posh-git-fba883f\profile.example.ps1'
Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}

### Add Visual Studio tools
$idePath = Get-VSIdePath.ps1
if ($idePath -and (test-path $idePath)) {
	$env:path += ";$idePath";
}
else {
	Write-Warning "Visual Studio was not found"
}

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
	[string]::format('Found .NET Fx; Adding [{0}] to path...', $newestFxPath)
	$env:path += [string]::format(';{0}', $newestFxPath)
}
else {
	Write-Warning ".NET Framework was not found"
}


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
### Define shortcuts for push & pop if they don't exist
# (Preferably they're defined in profile.ps1 for AllUsersAllHosts
if ($null -eq (get-alias p -ErrorAction SilentlyContinue) ) {
	set-alias p			pushd
}
if ($null -eq (get-alias pp -ErrorAction SilentlyContinue) ) {
	set-alias pp		popd
}
# Define shortcut for listing dirs only
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
