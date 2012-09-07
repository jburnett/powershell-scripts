# declare the array for collecting AVHDs
$avhds = @()
$masterVHD = $null

function AVHDsMissingMasterVHD($rgAVHDInfo)
{
    return ($rgAVHDInfo | where {$_.MasterVHD -eq $null})
}

function GatherAVHDs($basePath)
{
    # Find .avhd files; add their full path and parent's path
    get-childitem -recurse -path $basePath -include *.avhd | sort-object CreationTime | %{
        $item = New-Object System.Object
        $item | Add-Member -type NoteProperty -name FullName -value $_.FullName
        $item | Add-Member -type NoteProperty -name CreationTime -value $_.CreationTime
        $item | Add-Member -type NoteProperty -name ParentPath -value (get-vhdinfo $_.FullName).ParentPath
        $item | Add-Member -type NoteProperty -name MasterVHD -value $null

        # Add the new object to the array
        $avhds += $item
    }
    return $avhds
}

function GatherVHDs($basePath) {
    # NOTE: This script requires Hyper-V module (Import-Module HyperV)

    # Get disk info of attached VMs (except those that have no DiskImage info)
    $attachedVMDisks = get-vmdisk | where {$_.DiskImage -ne $null}

    # find all VHDs in search path
    $searchPath = 'D:\Hyper-V\'
    foreach ($vhdFile in ($vhds = get-childitem -recurse -path $searchPath -include *.vhd)) {

        $found = $attachedVMDisks | where {$_.DiskImage.tolower() -eq $vhdFile.FullName.tolower()}
    ##    write-host '$found: ' $found
        
    ##    if ($attachedVMDisks -contains $vhdFile.FullName.tolower()) {
        if ($found -ne $null) {
            $vhdFile | add-member -type NoteProperty -name IsAttached -value $true
        }
        else {
            $vhdFile | add-member -type NoteProperty -name IsAttached -value $false
        }
    }

    $vhds | ft -autosize -property FullName, IsAttached
}

function PercolateMaster($avhdFullName) {
    
    # find item matching the FullName param
    $item = $avhds | where {$_.FullName -eq $avhdFullName}
    ## DEBUG:
    if ($item -eq $null) { write-host 'ERROR: Could not find item with FullName = ' $avhdFullName; exit }

    # if this item's MasterVHD is null, then need to populate it    
    if ($item.MasterVHD -eq $null)
    {
        ## DEBUG:
##        if ($item.ParentPath -eq $null) { read-host -prompt 'ParentPath is null for FullName = ' $item.FullName }
        
        # if this item's parent is a VHD, then it's the master; set Master to the VHD path name
        if ($item.ParentPath.ToUpper().EndsWith(".VHD")) {
            $item.MasterVHD = $item.ParentPath
        }
        # otherwise, this item's parent is another AVHD; recurse to that item and look for Master; when Master is found,
        #  the master's path name will be returned while unwinding recursion; set MasterVHD with return value
        else {
            $item.MasterVHD = PercolateMaster($item.ParentPath)
        }
    }

    # this item's master is now known (either existed or was found via recursion); return this item's master path name
    return $item.MasterVHD
}


# TODO: would be nice to send paths to exclude; or maybe just a set of paths to check non-recursively
$searchPath = 'D:\Hyper-V\'
#$avhds = GatherVHDs($searchPath)
$avhds = GatherAVHDs($searchPath)

$needMaster = AVHDsMissingMasterVHD($avhds) | sort-object CreationTime -descending
## $needMaster | ft -autosize -property FullName, CreationTime, MasterVHD

while ($needMaster.Length -gt 0) {
    $null = PercolateMaster($needMaster[0].FullName)
    $needMaster= AVHDsMissingMasterVHD($avhds)
}

## $avhds | ft -autosize -property FullName, CreationTime, MasterVHD, ParentPath
$avhds | where {$_.MasterVHD -eq $null} | ft -autosize -property @{Expression={$_.FullName};Label='Potentially Orphaned AVHDs'}, CreationTime



