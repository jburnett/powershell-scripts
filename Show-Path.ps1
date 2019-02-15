# JB, 2019/02/06: detect duplicate entries
# J Burnett, 2012/09/04
#param([switch]$Sort )

$all = @()
$unique = @{}

$all = $env:path -split";"

foreach ($p in $all) {
    if ($unique.ContainsKey($p)) {
        $unique[$p] += 1
        Write-Verbose "#### $p is duplicate; $unique.Item($p)"
    }
    else {
        $unique.Add("$p", 0)
    }
}

Write-Host "==== Unique Paths ==="
foreach ($p in $unique.GetEnumerator()) {
    Write-Host $p.Key
}

Write-Host "==== Duplicate Paths ==="
foreach ($p in $unique.GetEnumerator()) {
    if ($p.Value -gt 0 ) {
        Write-Host $p.Key   "`t("$p.Value "duplicates)"
    }
}
