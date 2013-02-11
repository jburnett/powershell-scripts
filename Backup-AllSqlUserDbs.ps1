# TODO: get SQL instance by param
$sqlInstance = '.\dev1'
$includeSystemDbs = $false

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")  | out-null
$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') $sqlInstance

$systemDbs = @('master','model','msdb','tempdb')

$bkdir = $s.Settings.BackupDirectory

$s.Databases | % {
    $db = $_

	# TODO: if db name is in sysdbs && include sys dbs, backup it up
	# TODO: does it ever make sense to backup temp db?
	
    if ($db.IsSystemObject -eq $False -and $db.IsMirroringEnabled -eq $False) {
        $dbname = $db.Name
        $dt = get-date -format yyyyMMddHHmmss
        $dbbk = new-object ('Microsoft.SqlServer.Management.Smo.Backup')
        $dbbk.Action = 'Database'
        $dbbk.BackupSetDescription = "Full backup of " + $dbname
        $dbbk.BackupSetName = $dbname + " Backup"
        $dbbk.Database = $dbname
        $dbbk.MediaDescription = "Disk"
        $dbbk.Devices.AddDevice($bkdir + "\" + $dbname + "_db_" + $dt + ".bak", 'File')
        $dbbk.SqlBackup($s)

        if ($db.DatabaseOptions.RecoveryModel -ne 'Simple') {
            $dt = get-date -format yyyyMMddHHmmss
            $dbtrn = new-object ('Microsoft.SqlServer.Management.Smo.Backup')
            $dbtrn.Action = 'Log'
            $dbtrn.BackupSetDescription = "Trans Log backup of " + $dbname
            $dbtrn.BackupSetName = $dbname + " Backup"
            $dbtrn.Database = $dbname
            $dbtrn.MediaDescription = "Disk"
            $dbtrn.Devices.AddDevice($bkdir + "\" + $dbname + "_tlog_" + $dt + ".trn", 'File')
            $dbtrn.SqlBackup($s)
        }
    }
}