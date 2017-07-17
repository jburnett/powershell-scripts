$vsRootPath = ''

$vsCmnToolsPath = Get-VSCommonToolsPath.ps1
if ($vsCmnToolsPath -and (test-path $vsCmnToolsPath)) {
		$vsRootPath = gci IDE -path ($vsCmnToolsPath.Parent.FullName)
}
elseif (Test-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" ) {
	$vsRootPath = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath
	$vsRootPath += "/Common7/IDE"
}

return $vsRootPath


#----------------------------------------------------------------------------------------------------
# History
#	07/17/2017	Add support for VS2017's vswhere tool (IOW, dropped VSCOMNTOOLS env var)
#----------------------------------------------------------------------------------------------------
