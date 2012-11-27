#Usage: Run-SqlScripts.ps1 <database name> <SQL Server Instance name>
param([string]$Database="Evaluate_v14.3", [string]$SqlServerName="localhost", [string]$SqlInstanceName="")
# "Database: {0}" -f $Database
# "Server: {0}" -f $SqlServerName
# "Instance: {0}" -f $SqlInstanceName

$fqInstance = "localhost"
if ($SqlInstanceName -gt "") {
	$fqInstance += "\$SqlInstanceName"
}

# Run all sql scripts in current directory
foreach ($script in gci . *.sql) {
	osql.exe -E -S $fqInstance -d $Database -i $script.Name | tee "$script.log"
}