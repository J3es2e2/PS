Start-Transcript
Update-Help

#server OS only
#Install-WindowsFeature
#Get-WindowsFeature | where {$_. installed -eq "True"}

$NICname = Get-NetAdapter | %{$_.name}

$vmPath = "F:\DEMO2\"

$vmDCname = "DC_01"

$isoSrvPath  = "D:\Windows ISO\Server 2016 EVAL\"
$isoSrv = "Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO"


New-VM -Name $vmDCname -MemoryStartupBytes 4096mb -Path $vmPath -NewVHDPath ($vmPath + "\$vmDCname" + "_disk.vhdx") -NewVHDSizeBytes 30gb
Set-VM -Name $vmDCname -ProcessorCount 4
Add-VMDvdDrive -VMName $vmDCname -Path ($isoSrvPath + $isoSrv)
Set-VMProcessor -VMName $vmDCname  -ExposeVirtualizationExtensions $true
Get-VM -Name $vmDCname
$cowSrv = Get-VM -Name $vmDCname


New-VMSwitch -name $switch03  –NetAdapterName "Ethernet"  –AllowManagementOS $false
help New-VMSwitch -Full
Disable-VMSwitchExtension -VMSwitchName "Switch01" -Name "Ethernet 2"


Get-VMSwitch *



help Add-VMSwitch -full 
Add-VMSwitch -name $switch01 -ResourcePoolName "JJLab-03"


Get-Command -Module Hyper-V
gcm *network* -Module Hyper-V



#   V-Ethernet Default Switch IPv4  172.18.55.193(Preferred) Subnet Mask: 255.255.255.240
#   VBox H-O Ethernet   IPv4  192.168.3.1(Preferred) Subnet Mask : 255.255.255.0
#   E2500 Ethernet   IPv4 : 10.0.0.92(Preferred) Subnet Mask : 255.255.255.0    Default Gateway : 10.0.0.1

$Adapters = Get-NetAdapter * | Format-Table -Wrap -AutoSize
$Adapters



Get-VMNetworkAdapter *
help Add-VMNetworkAdapter -full

$switch03 = "Switch03 Private"

$vmDCname = "PSDC-03"
$VMDCAdap1 = ($vmDCName +"_NIC01")
$VMDCAdap2 = ($vmDCName +"_NIC02")
$switch01 = "Switch01 External"

$vmCliName = "PSCL-01"
$switch02 = "Switch02 internal"
$VMCliAdap = ($vmCliName +"_NIC01") 


New-VMSwitch -name $switch01  -SwitchType External –NetAdapterName "Ethernet"  –AllowManagementOS $true 
Add-VMSwitch -name $switch01 -ResourcePoolName "JJLab-03"

New-VMSwitch -name $switch02  -SwitchType Internal  –NetAdapterName "vEthernet"  –AllowManagementOS $true 
Add-VMSwitch -name $switch02 -ResourcePoolName "JJLab-03"

Add-VMNetworkAdapter -VMName $vmDCName -Name $VMDCAdap2  -SwitchName $switch02
Add-VMNetworkAdapter -VMName $vmCliName -Name $VMCliAdap  -SwitchName $switch02




Remove-VMNetworkAdapter -VMName $vmCliName -VMNetworkAdapterName $VMCliAdap -WhatIf
Remove-VMSwitch $switch02

Remove-VMNetworkAdapter -VMName $vmDCname -VMNetworkAdapterName $VMAdap 

Start-VM $vmDCname



Get-NetAdapter
New-VMSwitch -name Xternal -ComputerName "." -NetAdapterName "Ethernet"  -Notes " This switch is for the VMs" -confirm
New-VMSwitch -Name VMinternal -Notes "This switch is Internal Comm for the VMs" -SwitchType Internal -Confirm
ncpa.cpl
ipconfig /all
ipconfig
Stop-VM $vmDCname