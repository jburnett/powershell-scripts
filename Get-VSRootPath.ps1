$vsRootPath = ''

$vsCmnToolsPath = Get-VSCommonToolsPath.ps1
if (test-path $vsCmnToolsPath) {
		$vsRootPath = $vsCmnToolsPath.Parent.Parent
}
return $vsRootPath
