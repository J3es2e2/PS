#http://techgenix.com/nat-network-hyper-v-vms/

Get-VMSwitch

New-VMSwitch -Name "NATSW00" -SwitchType Internal

Get-VMSwitch

Get-NetAdapter

New-NetIPAddress -IPAddress 192.168.5.1 -PrefixLength 24 -InterfaceIndex 37

#New-NetNat -Name BriensNAT -ExternalIPInterfaceAddressPrefix 192.168.5.0/24
#gave....New-NetNat : The parameter is incorrect.
#A commenter suggest this Fix though  which runs , but does it do the same thing???

$NetNatName = 'JJLabNAT'
New-NetNat -Name $NetNatName  -InternalIPInterfaceAddressPrefix 192.168.5.0/24

Get-NetNat
Remove-NetNat $NetNatName
ncpa.cpl
ipconfig
