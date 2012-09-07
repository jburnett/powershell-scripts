add-type @'
public class DuResult
{
    public string Path = string.Empty;
    public string Files = System.String.Empty;
    public string Directories = System.String.Empty;
    public long Size = 0;
    public long SizeOnDisk = 0;
}
'@

# an array of du results
$results = @()

# Beginning at the current directory
$currDir = get-location;

# Get child directories
gci | ?{($_.PSIsContainer)} |

% { # with each child directory...
    # create obj to contain du results
    $obj = new-object DuResult
    # Add the inspected path to the obj
    $obj.Path = "$currDir\$_";
    
    # exec disk usage for the path
    $duInfo = & 'du.exe' -q $_

    # use regex to capture the numbers du returned     
    select-string '(\d+[,\d]*)' -input $duInfo -AllMatches | 
    % {
        if (0 -lt $_.Matches.Length)
        {
            $obj.Files = $_.Matches[0].Value 
            $obj.Directories = $_.Matches[1].Value
            $obj.Size = [long]::Parse($_.Matches[2].Value.Replace(",", ""))
            $obj.SizeOnDisk = [long]::Parse($_.Matches[3].Value.Replace(",", ""))
            # add it to the array
            $results += $obj
        }
    }
}

#"Disk usage of $currDir child directories:"
$results | sort-object Size -desc |
	ft -Auto Path, Files, Directories, @{Name="Size (MB)"; alignment="right"; Expression={"{0:N03}" -f ($_.Size / 1MB) }}, @{Name="Size On Disk (MB)"; alignment="right"; Expression={"{0:N03}" -f ($_.SizeOnDisk / 1MB) }}
