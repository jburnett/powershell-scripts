#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	This file belongs in $home\Documents\WindowsPowerShell\
#	If stored as Microsoft.PowerShell_profile.ps1, applies to CurrentUser, CurrentHost
#	If stored as profile.ps1, applies to CurrentUser, AllHosts
#
#	See end of file for history
#----------------------------------------------------------------------------------------------------

# Add shared modules location ahead of user's and Windows
$publicModulesPath = "$env:PUBLIC\Documents\WindowsPowerShell\Modules"
if (test-path $publicModulesPath) {
    $env:PSModulePath = "$publicModulesPath;$env:PSModulePath"
}

# Add PowerShell Community Extensions
$pscxPath = "$env:PUBLIC\Documents\WindowsPowerShell\Modules\Pscx"
if (test-path "$publicModulesPath\Pscx") {
    Import-Module Pscx
}

# Add PUBLIC scripts to path before user's
$publicScriptPath = "$env:PUBLIC\Documents\WindowsPowerShell"
if (test-path $publicScriptPath) {
    $env:path += ";$publicScriptPath"
}

# Add USER's scripts dir to path
$userScriptPath = "$env:USERPROFILE\Documents\WindowsPowerShell"
if (test-path $userScriptPath) {
    $env:path += ";$userScriptPath"
}

# Add Git tools to path. NOTE: git\cmd should alread be in path
$gitToolsRoot = (Get-Item "Env:ProgramFiles(x86)").Value + "\Git"
if (test-path $gitToolsRoot) {
    $env:path += ";$gitToolsRoot\bin"
    . Add-GitHelpers.ps1
}

# REMOVE: Documents\Scripts is archaic
# Add USER's scripts dir to path
$userScriptPath = "$home\Documents\Scripts"
if (test-path $userScriptPath) {
    $env:path += ";$userScriptPath"
}

# Alias for amount of free disk space
if (test-path "$publicScriptPath\DiskFreeSpace.ps1") {
    set-alias df       DiskFreeSpace.ps1	-ErrorAction SilentlyContinue
}

# Define shortcuts for push & pop if they don't exist
# (Preferably they're defined in profile.ps1 for AllUsersAllHosts
if ($null -eq (get-alias p -ErrorAction SilentlyContinue) ) {
	set-alias p			pushd
}
if ($null -eq (get-alias pp -ErrorAction SilentlyContinue) ) {
	set-alias pp		popd
}


#----------------------------------------------------------------------------------------------------
# J's PowerShell profile handler
#	05/14/12:	Added support for Pscx (PowerShell Community Extensions)
#----------------------------------------------------------------------------------------------------

# Load posh-git example profile
. 'C:\src\posh-git\profile.example.ps1'

