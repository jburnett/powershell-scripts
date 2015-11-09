
## Add-Path based on https://gist.github.com/vintem/6334646
function Add-Path() {
    [Cmdletbinding()]
    param([parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)][String[]]$AddedFolder)

    # Get the current search path from the environment keys in the registry.
    $OldPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path

    # See if a new folder has been supplied.
    if (!$AddedFolder) {
        Return 'No Folder Supplied. $ENV:PATH Unchanged'
    }
    # See if the new folder exists on the file system.
    if (!(TEST-PATH $AddedFolder)) {
		Return 'Folder Does not Exist, Cannot be added to $ENV:PATH'
    }
#	cd
    # See if the new Folder is already in the path.
    if ($ENV:PATH | Select-String -SimpleMatch $AddedFolder) {
		Return 'Folder already within $ENV:PATH'
    }
    
    # Set the New Path
    $NewPath=$OldPath+';'+$AddedFolder
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath
    # Show our results back to the world
    Return $NewPath
}


######################################################
# Install apps using Chocolatey
######################################################
Write-Host "Installing Chocolatey"
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
#iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))
Write-Host

######################################################
# Install BoxStarter and import into this shell session
######################################################
Write-Host "Installing BoxStarter"
cinst boxstarter
. $Env:UserProfile/appdata\Roaming\Boxstarter\BoxstarterShell.ps1


######################################################
# Use BoxStarter to set Windows config
######################################################
Disable-InternetExplorerESC
Enable-RemoteDesktop
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

Disable-MicrosoftUpdate		# Temporarily disable MS Updates; see Install-WindowsUpdate at end of script

Write-BoxstarterMessage "Setting Windows power plan to High Performance"
$guid = (Get-WmiObject -Class win32_powerplan -Namespace root\cimv2\power -Filter "ElementName='High performance'").InstanceID.tostring()
$regex = [regex]"{(.*?)}$"
$newpowerVal = $regex.Match($guid).groups[1].value
powercfg -S $newpowerVal
 
Write-BoxstarterMessage "Setting Standby Timeout to Never"
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
 
Write-BoxstarterMessage "Setting Monitor Timeout to Never"
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
 
Write-BoxstarterMessage "Setting Disk Timeout to Never"
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
 
Write-BoxstarterMessage "Turning off Windows Hibernation"
powercfg -h off

$timezone = 'Eastern Standard Time' 
Write-BoxstarterMessage "Setting time zone to $timezone"
& C:\Windows\system32\tzutil /s ""$timezone""


Write-Host "Installing applications using Chocolatey"
cinst git
######################################################
# Add Git to the path
######################################################
Write-Host "Adding Git\bin to the path"
Add-Path "C:\Program Files (x86)\Git\bin"
Write-Host

cinst poshgit

cinst notepadplusplus
######################################################
# Add Notepad++ to the path
######################################################
Write-Host "Adding Notepad++ to the path"
Add-Path "C:\Program Files (x86)\Notepad++"
Set-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"
Write-Host


cinst ConEmu

cinst SysInternals
######################################################
# Add SysInternals to the path
######################################################
Write-Host 'Adding SysInternals to the path'
Add-Path 'C:\tools\SysInternals'
Write-Host

cinst DotNet4.5.2

cinst GoogleChrome-AllUsers
cinst fiddler4
# "C:\Program Files (x86)\Fiddler2\Fiddler.exe"
cinst winmerge
# "C:\Program Files (x86)\WinMerge\WinMergeU.exe"
cinst NugetPackageExplorer  # installs desktop icon
Write-Host

######################################################
# Set environment variables
######################################################
Write-Host "Setting home variable"
[Environment]::SetEnvironmentVariable("HOME", $HOME, "User")
[Environment]::SetEnvironmentVariable("CHROME_BIN", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", "User")
# [Environment]::SetEnvironmentVariable("PHANTOMJS_BIN", "C:\tools\PhanomJS\phantomjs.exe", "User")
Write-Host

######################################################
# Configure Git globals
######################################################
# Write-Host "Configuring Git globals" 
#$userName = Read-Host 'Enter your name for git configuration'
$userName = 'J Burnett'
#$userEmail = Read-Host 'Enter your email for git configuration'
$userEmail = 'jburnett@altamodatech.com'

& git config --global user.email $userEmail
& git config --global user.name $userName


######################################################
# Use BoxStarter commands to get MS updates
######################################################
Install-WindowsUpdate -AcceptEula -SuppressReboots
if (Test-PendingReboot) { Invoke-Reboot }