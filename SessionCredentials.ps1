Get-CimSession | Remove-CimSession -verbose

winrm.cmd set winrm/config/client '@{TrustedHosts = "10.0.0.250,10.0.0.151,10.0.0.92,10.0.0.200,10.0.0.225"}'

$cim092 = New-CimSession -ComputerName '10.0.0.92'  -Credential 'JJJ'
$cim250 = New-CimSession -ComputerName '10.0.0.250' -Credential 'JJJessee'
$cim151 = New-CimSession -ComputerName '10.0.0.151' -Credential 'JJJessee'
$cim200 = New-CimSession -ComputerName '10.0.0.200' -Credential 'Owner'
$cim225 = New-CimSession -ComputerName '10.0.0.225' -Credential 'jj@bristolsign.com'

$cimArray = '$cim092, $cim250, $cim151, $cim200, $cim225'

$tArray = 1, 2, 3, 4, 5, 6
[array]::Reverse($tArray)
$tArray

Test-Connection 10.0.0.225 | Format-Table -AutoSize

$pss = New-PSSession '10.0.0.200' -Credential 'Owner'