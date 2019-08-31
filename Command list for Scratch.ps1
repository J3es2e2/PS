# already used
Add-VMDvdDrive -VMName $VMname -Path "C:\Users\JJJessee\MSCA Certification\ISO\Server 2016\"

Add-VMNetworkAdapter -VMName $vmCliName01 `

Enter-PSSession -VMName $vmCliName01 

Exit-PSSession 



Get-VM -Name $VMname

Get-VMSwitch * | Format-Table -Wrap -AutoSize

Get-VMNetworkAdapter -all | Format-Table -Wrap -AutoSize

Get-NetIPAddress | Select-Object -Property  InterfaceIndex, PrefixOrigin, IPAddress, InterfaceAlias, PrefixLength, AddressFamily `
  
Get-VMSwitch * | Format-Table -Wrap -AutoSize

Invoke-Command -VMName VMName -ScriptBlock { `
      Get-NetIPAddress | Select-Object -Property  InterfaceIndex, PrefixOrigin, IPAddress, InterfaceAlias, PrefixLength, AddressFamily `
      | Where-Object {($_.AddressFamily -eq 'ipv4')} `
      | Format-Table -Wrap -AutoSize }`

New-NetIPAddress –InterfaceIndex $myifIndex -IPAddress $myIP4  –PrefixLength $myCIDR 

New-VM -Name $VMname -MemoryStartupBytes 1024mb -Path $vmPath -NewVHDPath $vmPath + "\disk.vhdx" -NewVHDSizeBytes 10gb

New-VMSwitch "Switch01" –NetAdapterName "Ethernet 2"  –AllowManagementOS $false

Set-Location   $env:windir\system
mmc virtmgmt.msc

Set-VM -Name $VMname -ProcessorCount 4

Start-VM $VMname

Stop-VM $VMname

ipconfig 







# try theses

Test-VMNetworkAdapter

#suggestion pool
Add-VMNetworkAdapter
Connect-VMNetworkAdapter
Disconnect-VMNetworkAdapter
Get-VMNetworkAdapter
Remove-VMNetworkAdapter
Rename-VMNetworkAdapter
Set-VMNetworkAdapter