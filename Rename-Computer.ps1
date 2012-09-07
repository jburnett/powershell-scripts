function renameAndReboot([string]$computer, [string]$newname)
{
        $comp = gwmi win32_computersystem  -computerName $computer
        $os   = gwmi win32_operatingsystem -computerName $computer

        Write-Host "Renaming $computer to $newname..."
        $comp.Rename($newname)
        
        Write-Host "REBOOTING computer..."
        $os.Reboot()
}

$currComputerName = gc Env:\COMPUTERNAME
$newComputerName = Read-Host "Rename $currComputerName to: " -OutVariable $dlgResult
if ($null -eq $newComputerName -or 8 -gt $newComputerName.Length) {
    if ($null -eq $newComputerName) {
        Write-Host "You must enter a new computer name."
    }
    else {
        Write-Host "$newComputerName is too short. Computer name must be 8 or more characters"
    }
}
else {
#    write-host "New Name: $newComputerName"
#    write-host "Dialog result: $dlgResult"
    renameAndReboot $currComputerName $newComputerName
}
