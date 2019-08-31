set-content 'test.txt' "this is text"
for ($i = 1
   $i -lt 8
   $i++) {
   Add-Content 'test.txt' $i, "this is text"
}



get-help Add-Content  -ShowWindow

set-content 'test.txt' "this is text" -Encoding ascii



(Get-Content test.txt) | ForEach-Object { $_ -replace "text", "TEXTY" } | Set-Content test.txt


$embed = "HELPPP"
$myVar = @"
Line ONE
Line TWO /t $embed
Line ???
"@
$myVar

$myvar = @{Line1 = "This is Line1"
           Line2 = "This is Line2" 
}
   
$myVar = @{
   Path  = "Test.txt"
   Value = "SPLATTED"
}
Set-Content @myVar


$myVar = [PSCustomObject] @{
   Path   = "Test.txt"
   Value  = "SPLATTED"
   NUMBER = 89
}


$myVar = [DateTime] "2019-07-31"
$myVar
$myVar.ToString()
"Oops: $myvar"
"Instead.... $($myVar.ToString())"

$env:COMPUTERNAME 

ping $env:COMPUTERNAME -n 4

$myCom = "ping"

.$myCom $env:COMPUTERNAME -n 4



Enable-PSRemoting

$allowUnencrypted = "WSMan:\localhost\Client\AllowUnencrypted"

Get-ChildItem $allowUnencrypted

Set-Item $allowUnencrypted $true

$trustedHosts = "WSMan:\localhost\Client\TrustedHosts"

Get-ChildItem $trustedHosts

Set-Item $trustedHosts *

$RemoteSurface = "Surface-JJ"
$RemoteLenovo = "LENOVO-TC"
$RemoteDell = "Dell570" #Owner credentials allows remoting, other Admin not so much
$DellIP = "192.168.1.180"

Invoke-Command $RemoteDell { Dir C:\ } -Credential 'Owner'
Invoke-Command -ComputerName $RemoteLenovo { Dir C:\ } -Credential 'JJJ'
Invoke-Command -ComputerName $RemoteSurface { Dir C:\ } -Credential 'JJJessee'

$driveName = "C:\"

Invoke-Command $RemotePC011 { Dir $using:driveName }

Invoke-Command 192.168.1.180 { ipconfig /all} -Credential 'JJJ'