#requires -version 3
# Templated from http://9to5it.com/powershell-script-template/

#------------------------------[CmdletBinding]------------------------------
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False)] [string]$Path = '.',
    [switch]$Recurse,
    [switch]$Log
)

#------------------------------[Initialisations]------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"


#------------------------------[Declarations]------------------------------

#Script Version
$ScriptVersion = "1.0"

#Log File Info
$LogPath = "$env:TEMP"
$LogName = "Find-GitRepos.log"
$LogFile = join-path $LogPath $LogName

#------------------------------[Functions]------------------------------

#------------------------------[Execution - Preliminaries]------------------------------

if ($Log) {
    Start-Transcript $LogFile -Append
    Write-Verbose "Started transcript in $LogFile"
}


#------------------------------[Execution - Core]------------------------------

# This is the core functionality of the script.  The following is sample code
#   that shows the values of parameters.


gci $Path .git -Directory -Recurse -Force | ForEach-Object {
    $_.Parent.FullName
}


if ($Log) {
    Write-Verbose "Stopping transcript in $LogFile"
    Stop-Transcript
}

#------------------------------[Comment-based Help]------------------------------
<#
.SYNOPSIS
	Returns full path to git repositories.

.DESCRIPTION
	Recursively finds git repositories beginning in the current or provided path

.PARAMETER Path
    File path to search
	
.INPUTS
  None

.OUTPUTS
  Full path of git repositories (e.g, parent path of .git)

.NOTES
  Version:        1.0
  Author:         J Burnett
  Creation Date:  08/23/2017
  Purpose/Change: Initial script development
  
.EXAMPLE
  Find-GitRepos -Path c:\source
#>


