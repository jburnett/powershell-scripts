#requires -version 3

[CmdletBinding()] Param( ) # enables verbose


$vsRootPath = ''

$vsCmnToolsPath = Get-VSCommonToolsPath.ps1
Write-Verbose "received CmnToolsPath = $vsCmnToolsPath"

if ($vsCmnToolsPath -and (test-path $vsCmnToolsPath)) {
	$searchBeginPath = $vsCmnToolsPath.Parent.FullName
	write-verbose "gci for IDE under $searchBeginPath"
	$vsRootPath = gci IDE -path $searchBeginPath -Directory
}
# elseif (Test-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" ) {
# 	$vsRootPath = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath
# 	$vsRootPath += "/Common7/IDE"
# 	$vsRootPath = get-item -Path $vsRootPath
# }

Write-Verbose "VS root path is $vsRootPath"
$vsIDEPath = $vsRootPath.FullName
Write-Verbose "Get-VSIDEPath returning $vsIDEPath"
return $vsIDEPath


#----------------------------------------------------------------------------------------------------
# History
#	07/17/2017	Add support for VS2017's vswhere tool (IOW, dropped VSCOMNTOOLS env var)
#----------------------------------------------------------------------------------------------------
