#region ....Create  net Adapters...
# on  two Windows 10 Clients and connect them  an Internal Switch

#endregion

#region ...Variable declarations...

#our preciously created virtual switch
$VMSwitchName = "VMinternal"

#our previously created Windows 10 virtual machines
$vmCliName01 = "Client_01" 
$vmCliName02 = "Client_02" 

# In this lab execise, the virtual network adapters that will be created in them and configired
$VMCliAdap01 = ($vmCliName01 + "_NIC01")
$VMCliAdap02 = ($vmCliName02 + "_NIC02") 

#endregion

#region ....Starting with a clean slate

Remove-VMNetworkAdapter -VMName $vmCliName01 -VMNetworkAdapterName $VMCliAdap01

Remove-VMNetworkAdapter -VMName $vmCliName02 -VMNetworkAdapterName $VMCliAdap02

Get-VMSwitch * | Format-Table -Wrap -AutoSize

Get-VMNetworkAdapter -all | Format-Table -Wrap -AutoSize

Get-NetIPAddress | Select-Object `
    -Property  InterfaceIndex, PrefixOrigin, IPAddress, InterfaceAlias, PrefixLength, AddressFamily `
    | where {($_.AddressFamily -eq 'ipv4')} `
    | Format-Table -Wrap -AutoSize 

#endregion

#region ....Creating the two adapters...
# Make sure the Clients are off, Hyper-V Manager can be running, but not the Clients
#  We are suppling our own Static Mac Address for simplicity and sake of making absolutely sure MAC Address conflicts in the real/virtual world
# I'm sure there are ways and reasons to manage Dynamically assigned MACs, but you can begin reseach here for more understanding
# https://blogs.technet.microsoft.com/jhoward/2008/07/15/hyper-v-mac-address-allocation-and-apparent-network-issues-mac-collisions-can-cause/
# The Hyper-V manager by default offers a range of 256 or 8 bits of address based on the Microsoft IEEE Organizationally Unique Identifier, 00-15-5D,
# plus 2 more hex tuples that are derived from the lowest two octects of an IPv4 address on the server,
# and the final 8 bits are open to assignment by default
# to recap using the VM adapters we about to define
# 00-15-5D   Microsoft IEEE Organizationally Unique Identifier
# 07-CF or 7.207.x.x
# at least that's what the link says, but my current Hyper-V default range does not seem to be related to any IPv4 address that I see ????




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


<# if using the Hyper-V Manager to monitor progress.
   make sure Clients are OFF, then the Manger must be turned off/on 
   -full restart to make sure everything updates 
#>

cd $env:windir\system
mmc virtmgmt.msc

#endregion

#region ....Setting IP Addresses...
<#
    While there is a Set-VMNetworkAdapter commandlet, it does not have an IP Address property
    that will allow us to set allow us to reach into the plainly visible VM Adapters and 
    bend them to our static IP address desires
    As I continue to learn PS, that obsticle may seem more reasonable.

    But there is a fairly simple solution. PS allows us to create a Session on 
    OTHER COMPUTERS. It essentially brings the PS command line (a shell session)
    to our Physical Host terminal. The target computer must be in an ON state 
    and we will need to supply administrative privledges (password) to start the session. 
#>


help Set-VMNetworkAdapter -Full


#The VM must be in a running state
Enter-PSSession -VMName $vmCliName01 

# Should I be running as ADMIN ?????

<#
   
    Once 'inside' we issue commands as if the remote target, in this case a VM Client,
    is our Physical Host. Notice the change of command line prompt

    [Client_01]: PS C:\Users....

    The variables we need are not scoped to our new session need to be redeclared
#>


#our previously created virtual switch
$VMSwitchName = "VMinternal"

#our previously created Windows 10 virtual machines
$vmCliName01 = "Client_01" 
$vmCliName02 = "Client_02" 

#the virtual network adapters that will created in them and configured
$VMCliAdap01 = ($vmCliName01 + "_NIC01")
$VMCliAdap02 = ($vmCliName02 + "_NIC02") 

<#
   #not a problem if you keep your declaration in designated regions

#>


#Format-Table -Wrap -AutoSize
<#
    uh-oh, Once the Client with the new VM adapter we created with a dynamic MAC address
    is started, the blank, 000000000000 addres is filled with a 'legit looking' MAC address/
    AND it is given a generic name, Ethernet x
    what does persist on both sides of the session wall is the new MAC address

    so... perhaps the leanest solution is to inject a static MAC at VM Adapter creation
    and us it as seek & set handle for when we 

    
    Enter-PSSession -VMName $vmCliName01
    
    it could werk...so Exit-PSSession

    To select a "good" static MAC Address, 
    I looked at the Global Network Settings -MAC Address Range on the Hyper Manager
    and took a stab in the dark for a couple of addresses from the pool of 255 (xFF) 
    that are at least 'in bounds"....remove the old VM adapters....
    ...create them afresh with a Static MAC...so far so good.
#>

#endregion
 
#region ....Set the ADdresses .....

$MACAdd01 = '00-15-5D-C6-CB-20'
$myIP401 = "192.168.5.111"
$myCIDR01 = 24

$MACAdd02 = "00-15-5D-C6-CB-21"
$myIP402 = "192.168.5.112"
$myCIDR02 = 24
 


$x = Get-NetAdapter * | Select-Object * | where {$_.MacAddress -eq $MACAdd01} 
$x
$myClientIfIndex = $x.ifIndex

$myClientIfIndex

Get-NetAdapter * | Select-Object -Property MacAddress, AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex, SuffixOrigin `
    | where {($_.MacAddress -eq $MACAdd01 )}


$Adapter = Get-NetIPAddress `
    | Select-Object -Property  AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex, SuffixOrigin `
    | where { ($_.InterfaceIndex -eq $myClientIfIndex )}
    
#  -and ($_.SuffixOrigin -eq "Manual")}

Get-NetAdapter | Where-Object {($_.InterfaceIndex -eq $myClientIfIndex)} | New-NetIPAddress -IPAddress $myIP401 -PrefixLength 24 



help Set-NetIPAddress -Full
Exit-PSSession 

#endregion


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
