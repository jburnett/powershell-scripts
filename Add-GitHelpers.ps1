#----------------------------------------------------------------------------------------------------
# J's Git Helpers for PowerShell.  History at end of file
#----------------------------------------------------------------------------------------------------

# If Git isn't found, this script was called by mistake.
# NOTE: git\cmd should alread be in path
$gitToolsRoot = (Get-Item "Env:ProgramFiles(x86)").Value + "\Git"
if ($true -ne (test-path $gitToolsRoot)) {
    echo "Error: Expected to find Git tools in $gitToolsRoot/bin"
    return
}

# Create alias for git status
function Git-Status {git.exe status $args}
set-alias   gs      Git-Status

#----------------------------------------------------------------------------------------------------
# J's Git Helpers for PowerShell
#       09/07/2012:       Created
#----------------------------------------------------------------------------------------------------