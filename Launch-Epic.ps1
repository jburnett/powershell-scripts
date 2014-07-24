#=====
# Purpose: Causes Epic to forget the Enterprise setting - allowing user to specify 
#	desired Enterprise at login.
# Usage: 
# History:
#	2014-07-24, J Burnett	Created
#=====

param (
	[string] [AllowEmptyString()] $EnterpriseID = ''	#defaults to empty string
)
#	,[string] $databaseName

# Is Epic client app installed
$epicClientApp = "C:\ASI\ASI.TAM\ThinClient\Software\ASI.SMART.Client.Frame.exe"
if (test-path $epicClientApp) {

	# Does the SMART.config file exist?
	$thinClientPath = "$env:UserProfile\AppData\Roaming\ASI.TAM\ThinClient"
	$smartConfigFile = "SMART.config"
	if (test-path $thinClientPath\$smartConfigFile) {
	
		# Change EnterpriseID and LastUsedDatabaseName
		[xml] $smartConfigXml = get-content "$thinClientPath\$smartConfigFile"
		$smartConfigXml.AppSettings.EnterpriseID = $EnterpriseID.ToUpper()
		# TODO: allow specifying database name separately
		$smartConfigXml.AppSettings.LastUsedDatabaseName = $EnterpriseID.ToUpper()
		$smartConfigXml.Save("$thinClientPath\$smartConfigFile")

	}

	# Launch Epic
	& $epicClientApp Home
}

<#
.SYNOPSIS
Launches Epic using the provided EnterpriseID, or with no EnterpriseID if not specified.


.DESCRIPTION
WARNING: The EnterpriseID and LastUsedDatabaseName settings in the current user's SMART.config file will be changed or removed by this script!

.PARAMETER EnvironmentID
The Epic EnvironmentID to be used when the Epic client starts.  If not specified, the current value will be removed from the config file.


.EXAMPLE
Launch Epic client with the ability to provide an EnterpriseID at logon.

Launch-Epic


.EXAMPLE
Launch Epic client using a specific EnterpriseID ('bohemoth' in this case)

Launch-Epic -EnterpriseID bohemoth

.NOTES
WARNING: The EnterpriseID and LastUsedDatabaseName settings in the current user's SMART.config file will be changed or removed by this script!

#>
