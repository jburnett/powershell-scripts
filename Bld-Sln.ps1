# ==============================================================================
# Builds solution (.SLN) using MSBuild. Options:
#	-Recurse - builds all solutions in current and child directories
#	-Clean - cleans each solution rather than build
#
#	TODO: impl config options, e.g, debug, release, all, etc.  May need to do 
#		some form of pattern matching for building special configs (codecov)
# ==============================================================================

param (
    [switch] $Recurse,
    [switch] $Clean
)

$slnFound = @()
if ($Recurse) {
	$slnFound = get-childitem . *.sln -Recurse
}
else {
	$slnFound = get-childitem . *.sln
}

if (0 -lt $slnFound.Count) {
	$slnFound | %{
		echo $_.FullName
		if ($Clean) {
			msbuild.exe $_.FullName /t:clean
		}
		else {
			msbuild.exe $_.FullName
		}
	}
}

#------------------------------[Comment-based Help]------------------------------

<#
.SYNOPSIS
	Builds Visual Studio solution(s) using MSBuild


.PARAMETER Recurse
    Build all solutions in current and child directories

.PARAMETER Clean
	Cleans each solution rather than build

.OUTPUTS


.NOTES
  Version:        1.0
  Author:         J Burnett
  Creation Date:  5/20/2014
  Purpose/Change: Initial script development
  
.EXAMPLE
  Bld-Sln -Recurse

.EXAMPLE
  Bld-Sln -Recurse

#>