param (
	[Parameter(mandatory=$true)]
	[string]$PathToAppend
)
# Appends a file path to the env's path if
#  1) The file path exists
#  2) The file path is not in the path already

# TODO: consider broadening to 
#     Append-EnvItem -Env <env var name> -Value <value to append>
#  which would
#  1) Create the Env var if it does not exist
#  2) Append the value to the env var if
#     a) it exists (as can be determined)
#     b) is not already in the env value

if (test-path $PathToAppend) {
	$itemExists = $false
	foreach ($pathItem in ($env:path -split";")) {
		if ($pathItem -eq $PathToAppend) {
			echo "$PathToAppend matches $pathItem"
			$itemExists = $true
			break
		}
	}
	if (!$itemExists) {
		$env:path+=";$PathToAppend"
		echo "$PathToAppend appended to path"
	}
	else {
		echo "$PathToAppend already exists in path"
	}
}
else {
	throw new-object System.IO.DirectoryNotFoundException "Invalid Path $PathToAppend"
}