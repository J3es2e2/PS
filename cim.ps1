$computers = "Dell570, PC011-Desktop, Surface-JJ, LENOVO-TC, GBI5X32"
$computers

Get-WSManInstance wmicim2/win32_service -SelectorSet @{name = "winrm" }

Get-WmiObject win32_service -filter 'name="winrm"' | Select-Object -property *

Get-CimInstance win32_service -filter 'name="winrm"' | Select-Object -property *

Get-CimInstance Win32_ComputerSystem -ComputerName 'PC011-Desktop' | Select-Object -Property * 

winrm.cmd set winrm/config/client '@{TrustedHosts = "192.168.1.100, 192.168.1.150, 192.168.1.160, 192.168.1.170, 192.168.1.180" }'
 
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'PC011-DESKTOP, SURFACE-JJ, DELL570, Gigabyter-i5x32'

winrm.cmd get winrm/config

Enter-PSSession -ComputerName PC011-DESKTOP

Invoke-Command -ComputerName '192.168.1.100' -credential 'jj@bristolsign.com' { Get-Service -Name bits }




################################
$Win32_CS = Get-CimInstance Win32_ComputerSystem -ComputerName 'Surface-JJ'

$Win32_CS | Select-Object -property Name, PrimaryOwnerName, Domain, Model, NumberOfLogicalProcessors, TotalPhysicalMemory, UserName, Workgroup 

Get-CimInstance Win32_Property | Get-Member
Get-CimInstance Win32_ComputerSystem | Get-Member
$x = Get-CimInstance Win32_DiskDrive| Get-Member
$x = Get-CimInstance Win32_DiskDrive
$x.SerialNumber
