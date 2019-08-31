$array = @()

$array = @(12,32,43,56,65,76,78,98)

foreach($item in $array) {
    Write-Output $item
}  
Write-Output $array
