param (
	[Parameter(mandatory=$true)]
	[string]$LogFileToInspect
)
select-string "[1-9][0-9]*\w+error\(" $LogFileToInspect