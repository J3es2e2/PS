
 
$Computer01 = '192.168.1.200'
$Computer02 = '192.168.1.190'
$Computer03 = '192.168.1.180'
$Computer04 = '192.168.1.187'   #Surface
$Computer00 = '192.168.1.10'   #server

Get-WmiObject -class 'Win32_ComputerSystem' | Get-Member

Get-CimClass -classname 'Cim_NetworkAdapter'

Get-CimInstance -classname 'Cim_NetworkAdapter' | Get-Member | Format-Table -AutoSize



Get-CimInstance -classname 'Cim_NetworkAdapter' -Property 'name' | Format-Table  DeviceID, Name, MACAddress -AutoSize
 
winrm.cmd set winrm/config/client '@{TrustedHosts = "10.0.0.250,10.0.0.92,10.0.0.151"}'
Get-Item WSMan:\localhost\Service\RootSDDL
Get-Item WSMan:\pc011-desktop\Service\RootSDDL
Get-Item WSMan:\GBI5X32\Service\RootSDDL

$session = New-PSSession -ComputerName '10.0.0.92'

Set-PSSessionConfiguration microsoft.powershell -ShowSecurityDescriptorUI 
Enable-PSRemoting -force -verbose
Get-NetTCPConnection | Where-Object -Property LocalPort -eq 5985 | Format-Table -AutoSize
Test-WSMan -ComputerName '10.0.0.92'
Invoke-Command -ComputerName '10.0.0.92' -credential 'JJJ'
$session = New-PSSession -computername '10.0.0.92' -Credential 'JJJessee'
$sessionA = New-PSSession -computername '10.0.0.250' -Credential 'JJJessee'
Get-PSSession 
Enter-PSSession -computername '10.0.0.92'
Exit-PSSession
Remove-PSSession -name *

Get-CimInstance -classname 'Cim_NetworkAdapter' -ComputerName '10.0.0.250' | Format-Table -AutoSize
Get-CimInstance -classname 'Cim_NetworkAdapter' -ComputerName '10.0.0.92' | Format-Table -AutoSize

New-ItemProperty -Name localaccountfiltertokenpolicy -Path HKLM:\Software\microsoft\windows\currentVersion\Policies\System -PropertyType DWORD -value 1

New-CimSessionOption -Protocol Dcom

$NetAdaperterEnabled = Get-CimInstance -classname 'Cim_NetworkAdapter' `
   -ComputerName $Computer03 -Property '*' `
| Where-Object NetEnabled -eq $true `
| Format-Table  SystemName, DeviceID, Name, MACAddress, AdapterType -AutoSize
$NetAdaperterEnabled

$NetAdaperterEnabled = Get-CimInstance -classname 'Cim_NetworkAdapter' `
   -ComputerName $Computer01 -Property '*' `
| Where-Object NetEnabled -eq $true `
| Format-Table  SystemName, DeviceID, Name, MACAddress, AdapterType -AutoSize
$NetAdaperterEnabled

$NetAdaperterEnabled = Get-CimInstance -classname 'Cim_NetworkAdapter' `
   -ComputerName $Computer02 -Property '*' `
| Where-Object NetEnabled -eq $true `
| Format-Table  SystemName, DeviceID, Name, MACAddress, AdapterType -AutoSize
$NetAdaperterEnabled