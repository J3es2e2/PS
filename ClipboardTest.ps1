$testarray = @()

for ($i = 1
   $i -lt 8
   $i++) {
   $testarray += 'TEST ' + $i 
   $testarray += '=A' + $i + '*' + $i
}
$testarray
Set-Clipboard -Value $testarray 