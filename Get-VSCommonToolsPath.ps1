#requires -version 3

[CmdletBinding()] Param( ) # enables verbose

$vsCmnToolsPath = ''

# VS2017 began support for side-by-side VS instances.  The new vswhere tool provides list of installed VS, so use it if available;
#  otherwise, resort to older style of checking for env var.
if (Test-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" ) {
	@('Enterprise', 'Professional', 'Community') | %{
		$editionName = $_
		$vsRootPath = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath -products "Microsoft.VisualStudio.Product.$editionName"
		# if ($vsRootPath -and (test-path $vsRootPath)) {
		# 	write-verbose "Found base path using vswhere.  $vsRootPath"
		# }
		# else {
		# 	write-verbose "Didn't find root for $editionName"
		# }
	}
	if ($vsRootPath -and (test-path $vsRootPath)) {
		$vsCmnToolsPath = join-path $vsRootPath 'Common7/Tools'
		write-verbose "Found common tools path using vswhere $vsCmnToolsPath"
	}
	else {
		write-verbose "Found vswhere, but not root path"
	}
}
else {
	write-verbose "Didn't find vswhere. Trying older VS env vars..."

	# Loop thru prioritized list of VS Common Tools env var names; return the path value of the first env var found
	$envVarNames = @('VS140COMNTOOLS', 'VS130COMNTOOLS', 'VS120COMNTOOLS', 'VS110COMNTOOLS', 'VS100COMNTOOLS')

	foreach ($evar in $envVarNames ) {
		if ((test-path env:$evar)) {
			$vsCmnToolsPath = (get-item env:$evar -ErrorAction Stop).Value
			break
		}
	}
}

#write-verbose "Returning $vsCmnToolsPath"
return $vsCmnToolsPath
