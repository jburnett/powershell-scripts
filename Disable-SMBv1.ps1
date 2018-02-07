#Requires -RunAsAdministrator
#Requires -Version 3

### Disables SMB version 1
# J Burnett, 2018/02/07
#####

	
if ( (Get-WindowsOptionalFeature -FeatureName "SMB1Protocol" -Online).State -eq 'Enabled' ) {
    Write-Host "SMB version 1 is installed on $Env:COMPUTERNAME. Disabling requires rebooting Windows. Continue (y/N)?"  -ForegroundColor Yellow
    
    $userSelection = Read-Host
    switch ($userSelection) {
        Y { 
            Write-Host "Yes selected. Disabling SMBv1..."
            Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol
        }
        Default {
            Write-Host "SMBv1 will be unchanged."
        }
    }
}
else {
    Write-Host "SMB version 1 is disabled on $Env:COMPUTERNAME."
}
