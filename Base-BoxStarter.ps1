// From https://gist.github.com/vintem/6334646
//

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
    if (!(TEST-PATH $AddedFolder))
    { Return 'Folder Does not Exist, Cannot be added to $ENV:PATH' }cd
    # See if the new Folder is already in the path.
    if ($ENV:PATH | Select-String -SimpleMatch $AddedFolder)
    { Return 'Folder already within $ENV:PATH' }
    # Set the New Path
    $NewPath=$OldPath+’;’+$AddedFolder
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath
    # Show our results back to the world
    Return $NewPath
}

######################################################
# Install apps using Chocolatey
######################################################
Write-Host "Installing Chocolatey"
iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))
Write-Host

Write-Host "Installing applications from Chocolatey"
cinst git
cinst ruby -Version 1.9.3.44800
cinst nodejs.install
cinst PhantomJS
cinst webpi
cinst poshgit
cinst notepadplusplus
cinst sublimetext2
cinst SublimeText2.PackageControl
cinst SublimeText2.PowershellAlias
cinst ConEmu
cinst python
cinst DotNet4.0
cinst DotNet4.5
cinst putty
cinst Firefox
cinst GoogleChrome
cinst fiddler4
cinst filezilla
cinst dropbox
cinst winmerge
cinst kdiff3
cinst winrar -Version 4.20.0
cinst mongodb
cinst NugetPackageExplorer
cinst SkyDrive
cinst Evernote
cinst heroku-toolbelt 
Write-Host

######################################################
# Set environment variables
######################################################
Write-Host "Setting home variable"
[Environment]::SetEnvironmentVariable("HOME", $HOME, "User")
[Environment]::SetEnvironmentVariable("CHROME_BIN", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", "User")
[Environment]::SetEnvironmentVariable("PHANTOMJS_BIN", "C:\tools\PhanomJS\phantomjs.exe", "User")
Write-Host

######################################################
# Download custom .bashrc file
######################################################
Write-Host "Creating .bashrc file for use with Git Bash"
$filePath = $HOME + "\.bashrc"
New-Item $filePath -type file -value ((new-object net.webclient).DownloadString('http://vintem.me/winbashrc'))
Write-Host

######################################################
# Install Windows installer through WebPI
######################################################
Write-Host "Installing apps from WebPI"
cinst WindowsInstaller31 -source webpi
cinst WindowsInstaller45 -source webpi
Write-Host

######################################################
# Install SQL Express 2012
######################################################
Write-Host
do {
    $createSiteData = Read-Host "Do you want to install SQLExpress? (Y/N)"
} while ($createSiteData -ne "Y" -and $createSiteData -ne "N")
if ($createSiteData -eq "Y") {
    cinst SqlServer2012Express
}
Write-Host

######################################################
# Add Git to the path
######################################################
Write-Host "Adding Git\bin to the path"
Add-Path "C:\Program Files (x86)\Git\bin"
Write-Host

######################################################
# Configure Git globals
######################################################
Write-Host "Configuring Git globals"
$userName = Read-Host 'Enter your name for git configuration'
$userEmail = Read-Host 'Enter your email for git configuration'

& 'C:\Program Files (x86)\Git\bin\git' config --global user.email $userEmail
& 'C:\Program Files (x86)\Git\bin\git' config --global user.name $userName

$gitConfig = $home + "\.gitconfig"
Add-Content $gitConfig ((new-object net.webclient).DownloadString('http://vintem.me/mygitconfig'))

$gitexcludes = $home + "\.gitexcludes"
Add-Content $gitexcludes ((new-object net.webclient).DownloadString('http://vintem.me/gitexcludes'))
Write-Host

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

######################################################
# Update RubyGems and install some gems
######################################################
Write-Host "Update RubyGems"
C:\Chocolatey\bin\cinst ruby.devkit.ruby193
gem update --system
gem install bundler compass
Write-Host

######################################################
# Install npm packages
######################################################
Write-Host "Install NPM packages"
npm install -g yo grunt-cli karma bower jshint coffee-script nodemon generator-webapp generator-angular
Write-Host

######################################################
# Generate public/private rsa key pair
######################################################
Write-Host "Generating public/private rsa key pair"
Set-Location $home
$dirssh = "$home\.ssh"
mkdir $dirssh
$filersa = $dirssh + "\id_rsa"
ssh-keygen -t rsa -f $filersa -q -C $userEmail
Write-Host

######################################################
# Add MongoDB to the path
######################################################
Write-Host "Adding MongoDB to the path"
Add-Path "C:\MongoDB\bin"
Write-Host

######################################################
# Download custom PowerShell profile file
######################################################
Write-Host "Creating custom $profile for Powershell"
if (!(test-path $profile)) {
    New-Item -path $profile -type file -force
}
Add-Content $profile ((new-object net.webclient).DownloadString('http://vintem.me/profileps'))
Write-Host