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
