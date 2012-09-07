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

$vhds | sort-object IsAttached, FullName | ft -autosize -property FullName, IsAttached



