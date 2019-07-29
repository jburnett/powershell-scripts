#----------------------------------------------------------------------------------------------------
# J's Docker Helpers for PowerShell.  History at end of file
#----------------------------------------------------------------------------------------------------

# If Docker isn't found, this script was called by mistake.
# NOTE: Docker\Resources\bin should alread be in path
$dockerToolsRoot = ((Get-Command docker.exe).Path | Get-Item).Directory
if ((test-path $dockerToolsRoot)) {
    # Create aliases for docker commands
    function List-Containers { & docker.exe container ls -a }
    set-alias   dcls    List-Containers
    function List-Images { & docker.exe image ls }
    new-alias   dils    List-Images
    function Prune-All { & docker.exe system prune $args }
    set-alias   dsp     Prune-All

    Write-Host "Finished creating aliases"
}
else {
    Write-Error "Error: Could not find Docker tools"
    return
}

# # Create alias for git status
# function Git-Status {git.exe status $args}
# set-alias   gs      Git-Status

#----------------------------------------------------------------------------------------------------
# J's Git Helpers for PowerShell
#       07/19/2017:     Converted to find git on path so either 32- or 64-bit found
#       09/07/2012:     Created
#----------------------------------------------------------------------------------------------------