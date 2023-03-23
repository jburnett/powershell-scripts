#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	This file belongs in $home\Documents\WindowsPowerShell\
#	If stored as Microsoft.PowerShell_profile.ps1, applies to CurrentUser, CurrentHost
#	If stored as profile.ps1, applies to CurrentUser, AllHosts
#
#	See end of file for history
#----------------------------------------------------------------------------------------------------

### Make sure HOME is local drive (not ASI's N:)
#TODO: $env:HOME=$env:USERPROFILE

### Switch to user dir
Set-Location -Path $env:USERPROFILE

### Add USER's scripts dir to path
# TODO: set path based on Posh version
$userScriptPath = "$env:USERPROFILE\Documents\PowerShell"
if (test-path $userScriptPath) {
    $env:path += ";$userScriptPath"
}
### Add Git tools to path. NOTE: git\cmd should already be in path
if (Get-Command git.exe -ErrorAction SilentlyContinue) {
	$helpers = Join-Path -Path $userScriptPath -ChildPath ".\Add-GitHelpers.ps1"
	. $helpers
}

if (Get-Command docker.exe -ErrorAction SilentlyContinue) {
	$helpers = Join-Path -Path $userScriptPath -ChildPath ".\Add-DockerHelpers.ps1"
	. $helpers
}

### Load posh-git profile.
Import-Module posh-git
### Use oh-my-posh & tell it to use posh-git$
oh-my-posh.exe --init --shell pwsh --config ~/jburnett.omp.json | Invoke-Expression
$env:POSH_GIT_ENABLED = $true


### Add Visual Studio tools
$idePath = Get-VSIdePath.ps1
if ($idePath -and (test-path $idePath)) {
	$env:path += ";$idePath";
}
else {
	Write-Warning "Visual Studio was not found"
}

### Add Meld comparison tool
$meldToolsRoot = (Get-Item "Env:ProgramFiles(x86)").Value + "\Meld"
if (test-path $meldToolsRoot) {
	$env:path += ";$meldToolsRoot"
	# Reset diff alias to use Meld
	Set-Alias diff 'C:\Program Files (x86)\Meld\meld.exe' -Force -Option AllScope
}
else {
	"NOTE: Meld was not found"
}


### Golang settings
if (-not (test-path "c:\Program Files\Go\bin\go.exe")) {
    Write-Warning "GO was not found"
}

### Add GMake if installed
if (-not (Get-Command make.exe -ErrorAction SilentlyContinue)) {
	if (test-path "C:\Program Files (x86)\GnuWin32\bin") {
		$env:path += ";C:\Program Files (x86)\GnuWin32\bin"
	}
}


### Add GraphViz if it's installed
$graphViz = (Get-Item "Env:ProgramFiles").Value + "\GraphViz"
if (test-path $graphViz) {
    $env:path += ";$graphViz\bin"
}
else {
    "NOTE: GraphViz was not found"
}

### Use local/bin if it exists
$localBin = "$env:APPDATA/local/bin"
if (Test-Path $localBin) {
	$env:path += ";$localBin"
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
function Get-ChildContainers { Get-ChildItem | ?{$_.PSIsContainer} }		#NOTE: ls -ad works, too
if ($null -eq (get-alias ld -ErrorAction SilentlyContinue) ) {
	set-alias ld		Get-ChildContainers		# list dirs
}
if ($null -eq (get-alias ll -ErrorAction SilentlyContinue) ) {
    set-alias ll       Get-ChildItem
}

function touch {set-content -Path ($args[0]) -Value ($null)} 

#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	12/11/2021	Added oh-my-posh
#   10/31/2021  Dropped several areas: VS Code, dotnet; simplified GO, posh-git
#	07/22/2019	Use Add-DockerHelpers
#	06/25/2019	Force HOME to USERPROFILE for git performance
#	04/09/2019	Added Golang support; replace Beyond Compare with Meld
#	12/07/2017	Skip custom .NET detection and add to path
#	11/25/2017	Add $env:APPDATA/local/bin to path if it exists
#	08/16/2017	Use 64-bit VSCode; detect git installed without using specific path
#	05/11/2017	Use Import-Module for PoshGit
#	02/18/2017	Use Meld for diffs when Beyond Compare not found
#	02/16/2017	Updated PoshGit path for changed commit number
#	02/15/2017	Added touch fn
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
