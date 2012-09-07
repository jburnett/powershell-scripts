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
	'Visual Studio\VS2010SP1dvd1\Setup.exe'
	,'Visual Studio\VS10-KB2455033-x86.exe'
	,'Visual Studio\VC2005-KB2538242_x86.exe'
	,'Visual Studio\VC2005-KB2538242_x64.exe'
	,'Visual Studio\VS10SP1-KB2565057-x86.exe'
	,'Visual Studio\VS10SP1-KB2548139-x86.exe'
	,'Visual Studio\VS10SP1-KB2529927-v2-x86.exe'
	,'Visual Studio\VS10SP1-KB2547352-x86.exe'
	,'Visual Studio\VS10SP1-KB2581206.exe'
	,'Visual Studio\VS10-KB2542054-x86.exe'
	,'Visual Studio\VS10SP1-KB2549864-x86.exe'
)
$msuUpdates = @(
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

