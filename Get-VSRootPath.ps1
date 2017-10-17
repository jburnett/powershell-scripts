$vsRootPath = ''
#requires -version 3

$vsCmnToolsPath = Get-VSCommonToolsPath.ps1

$vsRootPath = (get-item $vsCmnToolsPath).Parent.Parent.FullName

return $vsRootPath
