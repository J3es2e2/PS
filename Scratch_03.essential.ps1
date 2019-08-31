
$VMSwitchName = "VMinternal"

$vmCliName01 = "Client_01" 
$vmCliName02 = "Client_02" 

$VMCliAdap01 = ($vmCliName01 + "_NIC01")
$VMCliAdap02 = ($vmCliName02 + "_NIC02") 

Stop-Vm -Name $vmCliName01

Stop-Vm -Name $vmCliName02

Remove-VMNetworkAdapter -VMName $vmCliName01 -VMNetworkAdapterName $VMCliAdap01

Remove-VMNetworkAdapter -VMName $vmCliName02 -VMNetworkAdapterName $VMCliAdap02

Get-VMSwitch * | Format-Table -Wrap -AutoSize

Get-VMNetworkAdapter -all | Format-Table -Wrap -AutoSize

Get-NetIPAddress | Select-Object `
    -Property  InterfaceIndex, PrefixOrigin, IPAddress, InterfaceAlias, PrefixLength, AddressFamily `
    | where {($_.AddressFamily -eq 'ipv4')} `
    | Format-Table -Wrap -AutoSize 


Add-VMNetworkAdapter -VMName $vmCliName01 `
    -Name $VMCliAdap01 `
    -SwitchName $VMSwitchName  `
    -StaticMacAddress "00155DC6CB20" `
    -Confirm

Add-VMNetworkAdapter -VMName $vmCliName02 `
    -Name $VMCliAdap02 `
    -SwitchName $VMSwitchName  `
    -StaticMacAddress "00155DC6CB21" `
    -Confirm

Get-VMNetworkAdapter *



Start-Vm -Name $vmCliName01 -asjob
Enter-PSSession -VMName $vmCliName01 

Start-Sleep 180

Start-Vm -Name $vmCliName02  

Start-Sleep 180

Enter-PSSession -VMName $vmCliName01 

$VMSwitchName = "VMinternal"

$vmCliName01 = "Client_01" 
$vmCliName02 = "Client_02" 

$VMCliAdap01 = ($vmCliName01 + "_NIC01")
$VMCliAdap02 = ($vmCliName02 + "_NIC02") 


$MACAdd01 = '00-15-5D-C6-CB-20'
$myIP401 = "192.168.8.111"
$myCIDR01 = 24


$x = Get-NetAdapter * | Select-Object * | where {$_.MacAddress -eq $MACAdd01} 
$x
$myClientIfIndex = $x.ifIndex

$myClientIfIndex

Get-NetAdapter * | Select-Object -Property MacAddress, AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex, SuffixOrigin `
    | where {($_.MacAddress -eq $MACAdd01 )}


$Adapter = Get-NetIPAddress `
    | Select-Object -Property  AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex, SuffixOrigin `
    | where { ($_.InterfaceIndex -eq $myClientIfIndex )}

$Adapter

Get-NetAdapter | Where-Object {($_.InterfaceIndex -eq $myClientIfIndex)} | New-NetIPAddress -IPAddress $myIP401 -PrefixLength 24 

Exit-PSSession 





 

$vmCliName02 = "Client_02" 

Start-Vm -Name $vmCliName02 -asjob  

Enter-PSSession -VMName $vmCliName02


$vmCliName02 = "Client_02" 

$VMSwitchName = "VMinternal"

$VMCliAdap02 = ($vmCliName02 + "_NIC02") 

$MACAdd02 = "00-15-5D-C6-CB-21"
$myIP402 = "192.168.7.112"
$myCIDR02 = 24
 


$x = Get-NetAdapter * | Select-Object * | where {$_.MacAddress -eq $MACAdd02} 
$x
$myClientIfIndex = $x.ifIndex

$myClientIfIndex

Get-NetAdapter * | Select-Object -Property MacAddress, AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex, SuffixOrigin `
    | where {($_.MacAddress -eq $MACAdd02 )}


$Adapter = Get-NetIPAddress `
    | Select-Object -Property  AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex, SuffixOrigin `
    | where { ($_.InterfaceIndex -eq $myClientIfIndex )}

$Adapter

Get-NetAdapter | Where-Object {($_.InterfaceIndex -eq $myClientIfIndex)} | New-NetIPAddress -IPAddress $myIP402 -PrefixLength 24 



Exit-PSSession 








#####################################

Add-VMNetworkAdapter -VMName $vmCliName02 -Name $VMCliAdap02  -SwitchName  $VMSwitchName

$x = Get-VM
Get-VMSwitch * | Format-Table -Wrap -AutoSize

Rename-VMNetworkAdapter -VMName $vmCliName01 -NewName $VMCliAdap01
Rename-VMNetworkAdapter -VMName $vmCliName02 -NewName $VMCliAdap02

Remove-VMNetworkAdapter -VMName $vmCliName01 -VMNetworkAdapterName $VMCliAdap01 -WhatIf 

ipconfig

#region an alternative to PSSession...
Invoke-Command -VMName VMName -ScriptBlock { `
        Get-NetIPAddress | Select-Object -Property  InterfaceIndex, PrefixOrigin, IPAddress, InterfaceAlias, PrefixLength, AddressFamily `
        | where {($_.AddressFamily -eq 'ipv4')} `
        | Format-Table -Wrap -AutoSize `
}
#endregion
