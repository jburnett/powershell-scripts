$vsRootPath = ''

$vsCmnToolsPath = Get-VSCommonToolsPath.ps1
if ($vsCmnToolsPath -and (test-path $vsCmnToolsPath)) {
		$vsRootPath = gci IDE -path ($vsCmnToolsPath.Parent.FullName)
}
return $vsRootPath.FullName
