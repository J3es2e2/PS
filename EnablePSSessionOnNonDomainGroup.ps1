hostname
Get-NetIPAddress -InterfaceAlias Ethernet | Format-Table -AutoSize

Get-NetConnectionProfile | select InterfaceAlias, NetworkCategory

Enable-PSRemoting -Force -Verbose

Get-NetTCPConnection |Where-Object -Property LocalPort -eq 5985

$Session = New-PSSession -ComputerName 10.0.0.250 -Credential 'JJJessee'

winrm set winrm/config/client '@{TrustedHosts = "10.0.0.250,10.0.0.92,10.0.0.151"}'

Get-WinEvent -ListLog *winrm*


Test-WSMan -ComputerName 10.0.0.250
Test-WSMan -ComputerName 10.0.0.92
Test-WSMan -ComputerName 10.0.0.151

Get-PSSession 

Remove-PSSession -Name winrm23

Get-Item WSMan:\gbi5x32\Service\RootSDDL
Get-Item WSMan:\SURFACE-JJ\Service\RootSDDL
Get-Item WSMan:\localhost\Service\RootSDDL

Invoke-Command -ComputerName 10.0.0.250 -Credential 'JJJessee'

Set-PSSessionConfiguration microsoft.powershell -ShowSecurityDescriptorUI

New-ItemProperty -Name localaccounttokenfilterpolicy -path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -PropertyType DWORD -Value 1

$Computer = 'gbi5x32'
Get-WmiObject Win32_OperatingSystem -ComputerName $Computer -Credential 'JJJessee' | select -ExpandProperty CSName 

Get-CimInstance -ClassName 'CimNetworkAdapter' -ComputerName '10.0.0.250'