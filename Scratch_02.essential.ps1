$VMSwitchName = "VMinternal"

Remove-VMSwitch -name $VMSwitchName 

$VMSwitchType = "Internal"

$VMSwitchNotes = "This Switch type allows VMs and their Physical Host to communicate with each other"

New-VMSwitch -name $VMSwitchName   -SwitchType $VMSwitchType -Notes $VMSwitchNotes

$myIfAlias = "vEthernet (" + $VMSwitchName + ")"
$myIP4 = "192.168.5.1"
$myCIDR = 24

New-NetIPAddress –InterfaceAlias $myIfAlias -IPAddress $myIP4  –PrefixLength $myCIDR

Get-NetIPAddress `
    | Select-Object -Property AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex `
    | where {($_.AddressFamily -eq 'ipv4') -and ($_.InterfaceAlias -eq $myIfAlias )}
