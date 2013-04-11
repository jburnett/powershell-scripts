param (
	[Parameter(mandatory=$true)][string] $SlnFile
)

<#

Project\("(?<projid>[^"]*)"\)\s=\s"[^"]+",\s"(?<projpath>[^"]+)",

#>

$projPathRegEx = 'Project\("[^"]*"\)\s=\s"[^"]+",\s"(?<projpath>[^"]+)",'
#select-string -Path $input_path -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value } 
select-string -Path $SlnFile -Pattern $projPathRegEx -AllMatches | % {
	write-verbose -f "{1} matches", $_.Matches.Length 
	$_.Matches | % {
		$_.Value,     "(",  $_.Captures['projpath']
	}
}
