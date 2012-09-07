$basePath = '\\AMTSrv01\Download\Microsoft\SharePoint\SharePoint2010'
$updates = @(
	'officeserver2010-kb2494022-fullfile-x64-glb.exe',
	'excelwebapp-kb2553094-fullfile-x64-glb.exe',
	'officeserver2010-kb2560890-fullfile-x64-glb.exe',
	'sharepointfoundation2010-kb2494001-fullfile-x64-glb.exe',
	'wordwebapp-kb2566450-fullfile-x64-glb.exe',
	'wordwebapp2010-kb2345015-fullfile-x64-glb.exe'
)

foreach ($upd in $updates) {
	$updPath = "$basePath\$upd"
	c:\users\jb2\documents\WindowsPowerShell\Run-Update.ps1 $updPath
}
