$basePath = '\\AMTSrv01\Download\Microsoft\'
$exeUpdates = @('Windows\Windows7\Windows-KB890830-x64-v4.1.exe', # Malicious s/w upd
    'DotNet\DotNet4.0\NDP40-KB2572078-x64.exe'
)
$msuUpdates = @('DotNet\DotNet3.5\Windows6.1-KB2572077-x64.msu',
    'Windows\Windows7\IE8-Windows6.1-KB2586448-x64.msu'
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

