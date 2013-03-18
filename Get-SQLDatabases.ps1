#function Get-SQLDatabases {
 param(
 [Parameter(mandatory=$true)]
 [string]$DBServer
 )
 [System.Reflection.Assembly]::LoadWithPartialName(‘Microsoft.SqlServer.SMO’) | Out-Null
 
$server = New-Object (‘Microsoft.SqlServer.Management.Smo.Server’) “$DBServer”
 $server.databases | ? {$_.ID -gt 4} | select Name
 
#}
