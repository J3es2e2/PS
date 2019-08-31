$hash = $null

$hash = @{}

$proc = Get-Process | Sort-Object -Property name -Unique

foreach ($p in $proc) {
    $hash.add($p.name,$p.Definition)
    }
$hash
