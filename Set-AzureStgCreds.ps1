$azAcct = 'uidevstg01'
$azKey = 'sgg66SqYr1lX8foVHnT+8dOieobNtWcchyHQHW3GeUWe/asSYkxTfPjDYISvCGp2vcmu15AgflXWcVmVCDixcw=='

$setCreds = $false
if ($env:AZURE_STORAGE_ACCOUNT) {
    echo "Azure Storage Account is set: $env:AZURE_STORAGE_ACCOUNT"

    if ($env:AZURE_STORAGE_ACCESS_KEY) {
        echo "Azure Storage Access Key is set"
    }
    else {
        echo "Azure Storage Access Key is NOT set"
        $setCreds = $true
    }
}
else {
    $setCreds = $true
}

if ($setCreds) {
    echo "Setting Azure Storage Account to $azAcct" 
    set AZURE_STORAGE_ACCOUNT=$azAcct
    echo "Setting Azure Storage Access Key"
    set AZURE_STORAGE_ACCESS_KEY=$azKey
}
