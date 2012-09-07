# Copyright AltaModa Technologies, 2011
# J Burnett, 9/13/2011

# Only 64-bit supported for now
if (! ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') ) {
	echo '!!! Only 64-bit platforms supported at this time !!!'
	echo ''
	return
}

$basePath = '\\AMTSrv01\Download\Microsoft\'
$exeUpdates = @(
	'KB890830-x64-v4.3.exe' 	# Malicious s/w upd, Dec 2011

	,'DotNet\DotNet3.5\Windows6.1-KB2572077-x86.exe'
	,'DotNet\DotNet3.5\Windows6.1-KB2572077-x64.exe'
	,'DotNet\DotNet3.5\Windows6.1-KB2656356-x64.exe'
	
    ,'DotNet\DotNet4.0\NDP40-KB2572078-x64.exe'
	,'DotNet\DotNet4.0\NDP40-KB2468871-v2-x64.exe'
	,'DotNet\DotNet4.0\NDP40-KB2533523-x64.exe'
	,'DotNet\DotNet4.0\NDP40-KB2656351-x64.exe'

	,'Silverlight\Silverlight4 (KB2617986).exe'
)
$msuUpdates = @(
	'DotNet\DotNet3.5\Windows6.1-KB2572077-x64.msu'
	,'DotNet\DotNet3.5\Windows6.1-KB2572077-x86.msu'
	,'DotNet\DotNet3.5\Windows6.1-KB2572077-x64.msu'

	'Windows\IE9-Windows6.1-KB2559049-x64.msu'
	,'Windows\IE9-Windows6.1-KB2618444-x64.msu'
	,'Windows\Windows6.1-KB2618444-x64.msu'
    ,'Windows\Windows7\IE8-Windows6.1-KB2586448-x64.msu'
	,'Windows\Win2008Srv\Windows6.1-KB2556532-x64.msu'
)

$updateParams = '/quiet /norestart'

foreach ($upd in $msuUpdates) {
    $wusaParams = "$basePath$upd $updateParams"
    start-process 'wusa.exe' -ArgumentList $wusaParams -Wait -PassThru
}

$updateParams = '/passive /norestart'
foreach ($upd in $exeUpdates) {
    start-process $basePath$upd -ArgumentList $updateParams -Wait -PassThru
}

