### Turns off Shutdown Event Tracking via registry
# J Burnett, 2013/10/03
#####

# Make sure the registry path exists; create it if necessary
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability'
if ($false -eq (test-path $regPath )) {
	new-item $regPath
}

# Set the reg key to turn off shutdown event tracking
set-itemproperty -Path $regPath -Name ShutdownReasonOn -Type DWord -Value 0

write-host "The value of ShutdownReasonOn is now" (get-itemproperty -Path $regPath).ShutdownReasonOn
