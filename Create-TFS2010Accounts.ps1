$tfsAcctNames = @("TFSService", "TFSReports", "TFSBuild", "WSSService")
$tfsAcctNames | foreach {
	write-host "Creating TFS Account: $_"
	.{.\Create-LocalUser $_ }
}
