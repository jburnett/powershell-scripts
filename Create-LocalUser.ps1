param([string]$userName, [string]$userPswd="Intellinet1")
#write-host "Args: userName=$userName; userPswd=$userPswd"

# Constants (from http://support.microsoft.com/kb/305144)
$DONT_EXPIRE_PASSWORD = 65536  #&H10000
#$TRUSTED_FOR_DELEGATION = 524288  #&H80000

function create-localuser ([string]$uName, [string]$uPswd) {
write-host "[create-localuser] / User Name: $uName"
write-host "[create-localuser] / User Password: $uPswd"
	$computer = [ADSI]"WinNT://."
	$user = $computer.Create("User", $uName)
	$user.setpassword($uPswd)
	$user.SetInfo()
	$user.UserFlags = $user.UserFlags + $DONT_EXPIRE_PASSWORD
	$user.Description = [string]"Intellinet default pswd #1"
	$user.SetInfo()
}

create-localuser $userName $userPswd