#----------------------------------------------------------------------------------------------------
# J's Git Helpers for PowerShell.  History at end of file
#----------------------------------------------------------------------------------------------------

# If Git isn't found, this script was called by mistake.
# NOTE: git\cmd should alread be in path
$gitToolsRoot = ((Get-Command git.exe).Path | Get-Item).Directory
if ((test-path $gitToolsRoot)) {
    # Create aliases for git
    function Git-Status {git.exe status $args}
    set-alias   gs      Git-Status
    function Git-Pull { git.exe pull $args }
    new-alias   gp   Git-Pull -Force -Option AllScope
    function Git-Fetch { git.exe fetch $args }
    set-alias   gf   Git-Pull
}
else {
    Write-Error "Error: Could not find Git tools"
    return
}

# Create alias for git status
function Git-Status {git.exe status $args}
set-alias   gs      Git-Status

#----------------------------------------------------------------------------------------------------
# J's Git Helpers for PowerShell
#       07/19/2017:     Converted to find git on path so either 32- or 64-bit found
#       09/07/2012:     Created
#----------------------------------------------------------------------------------------------------