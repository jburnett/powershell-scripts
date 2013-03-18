param(
 [Parameter(mandatory=$false)]
 [string]$DBServer = 'localhost',
 [Parameter(mandatory=$true)]
 [string]$SqlCommandFile
)

[System.Reflection.Assembly]::LoadWithPartialName(‘Microsoft.SqlServer.SMO’) | Out-Null
$server = New-Object (‘Microsoft.SqlServer.Management.Smo.Server’) “$DBServer”

# Get all databases
$server.databases |
    # filter out the system dbs
    ? {$_.ID -gt 4} |
        # for each user db
        % {
            write-host "Executing $SqlCommandFile on database $_ ..."
            sqlcmd.exe -E -S $DbServer -i $SqlCommandFile
        }

