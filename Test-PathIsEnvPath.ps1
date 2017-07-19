param (
	[string] $Path = '.'	#defaults to current dir
)

$isEnvPath = $false

if (Test-Path $Path) {

    foreach($testPath in  $env:path -split ";" ) {
        if ({get-item $testPath}.Directory -eq {get-item $Path}.Directory) {
            $isEnvPath = $true
        }
    }
}

$isEnvPath


#------------------------------[Comment-based Help]------------------------------

<#
.SYNOPSIS
	Determines if the given path is a member of the environment's paths

.DESCRIPTION
    It is frequently valuable to know whether a specific directory is a member of the environment's paths.
    For example, there is no need to add the path to the environment's paths if it is already a member.

.PARAMETER Path
    The path to check for membership in environment's paths.  Defaults to current directory.

.OUTPUTS
  Returns true if the given path is a member of the environment's paths; otherwise, False

.NOTES
  Version:        1.0
  Author:         J Burnett
  Creation Date:  7/2/2017
  Purpose/Change: Initial script development
  
.EXAMPLE
  Test-PathIsEnvPath -Path C:\Windows
#>