#requires -version 3

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
gci -Directory | ForEach-Object {

    # with each child directory...
    # create obj to contain du results
    $obj = new-object DuResult
    # Add the inspected path to the obj
    $obj.Path = "$currDir\$_";
    
    # exec disk usage for the path, output in CSV
    $duInfo = & du.exe -c -nobanner $_
    ### du csv output format:
    # Path, CurrentFileCount, CurrentFileSize, FileCount, DirectoryCount, DirectorySize, DirectorySizeOnDisk
    # "C:\src\bitbucket\jburnett\wip",31,33613887,479,132,74412525,76349440

    # Skip the heading row (0), split text by commas, and populate instance of class
    $pieces = $duInfo[1].Split(",")
    $obj.Files = $pieces[1]
    $obj.Directories = $pieces[4]
    $obj.Size = $pieces[5]
    $obj.SizeOnDisk = $pieces[6]

    # add instance to the array
    $results += $obj
}

#"Disk usage of $currDir child directories:"
$results | sort-object Size -desc |
	ft -Auto Path, Files, Directories, @{Name="Size (MB)"; alignment="right"; Expression={"{0:N03}" -f ($_.Size / 1MB) }}, @{Name="Size On Disk (MB)"; alignment="right"; Expression={"{0:N03}" -f ($_.SizeOnDisk / 1MB) }}
