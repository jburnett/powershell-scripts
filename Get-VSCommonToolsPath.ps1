# Loop thru prioritized list of VS Common Tools env var names; return the path value of the first env var found
$envVarNames = @('VS120COMNTOOLS', 'VS110COMNTOOLS', 'VS100COMNTOOLS')
$vsCmnToolsPath = ''

foreach ($evar in $envVarNames ) {
	if ((test-path env:$evar)) {
		$vsCmnToolsPath = (get-item env:$evar -ErrorAction Stop).Value
		break
	}
}

if ($vsCmnToolsPath -and (test-path $vsCmnToolsPath)) {
	return get-item $vsCmnToolsPath
}
else {
	return $vsCmnToolsPath;
}