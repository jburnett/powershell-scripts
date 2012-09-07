$baseVMName = "VS2010-Base"
$newVMName = $null

function cloneVM() {
    
    write-host "Cloning $newVMName..."
    $proc = start-process 'c:\Program Files\Oracle\VirtualBox\VBoxManage.exe' `
        -wait -PassThru `
        -argumentlist " clonehd $baseVMName.vdi $newVMName.vdi"
    if ($proc.ExitCode -ne 0) {
    ## TODO: replace w/better err msg
        write-host "Cloning process failed with code:" $proc.ExitCode
        $proc
    }
    
#    2.	Clone: vboxmanage clonehd VS2010-base.vdi VS2010-<month>.vdi

}

function setVMUUID {
#3.	Set UUID: vboxmanage internalcommands setvdiuuid 
    write-host "Setting new UUID in $newVMName..."
    $proc = start-process 'c:\Program Files\Oracle\VirtualBox\VBoxManage.exe' `
        -wait -PassThru `
        -argumentlist " internalcommands setvdiuuid $newVMName.vdi"
    if ($proc.ExitCode -ne 0) {
    ## TODO: replace w/better err msg
        write-host "Setting UUID process failed with code:" $proc.ExitCode
        $proc
    }
}

function main() {
    $month = get-date -format MMM
    $newVMName = "VS2010-$month"
    read-host "Build $newVMName ?"

# 1/9/11: path probs: must run from D:\.VirtualBox\HardDisks, but new .vdi created in
#  D:\AMTL2\Users\JB2\.VirtualBox\HardDisks & then setVMUUID doesn't find vdi
#  Need to control where vdi is created during cloning.
#    cloneVM
    setVMUUID
}

main
