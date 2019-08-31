#region ....Preface..
    #Objective: Create a Vitual Machine with a Windows 10 Pro x64 bit OS called Client_01
    #Specifications: 2GB RAM; 16GB Vitual Hard Drive for data; 1-DVD Drive; 1 Processor; No Netwark Adapter
#endregion

#region.....Declare New-VM variables

#name of VM
$vmCliName        = "Client_01"

#where VM will be stored
$vmPath           = "E:\DEMO_3\"

# DynamicMemory
$StartupMemory    = 2GB

#Location of new blank Data Drive 
$vmDataDrivePath  =  ($vmPath + "\$vmCliName" + "_disk.vhdx")
$vmDataDriveSize  =  16GB

#endregion

#region.....Declare Set-VM variables


#Location of System Drive Master copy to be cloned
$isoPath   = "D:\Windows_ISO\Win10_64x\Windows10.iso"


#number of Processors
$Processors     = 2

# VM Generation (1 or 2)
$vmGeneration   = 2

## Memory (Static = 0 or Dynamic = 1)
$Memory         = 1
# StaticMemory
$StaticMemory   = 8GB
 
# DynamicMemory
$MinMemory      = 1GB
$MaxMemory      = 4GB

#Memory monitoring
#Get-VM | where DynamicMemoryEnabled -eq $true | select Name, `
#MemoryAssigned, MemoryMinimum, MemoryMaximum, MemoryDemand | ConvertTo-Csv -NoTypeInformation | Add-Content -Path C:\Logs\DynamicMemoryReport.csv

#endregion

#region ....Execute commands...

New-VM  -Name $vmCliName `
        -MemoryStartupBytes $StartupMemory `
        -Path $vmPath `
        -NewVHDPath $vmDataDrivePath `
        -NewVHDSizeBytes  $vmDataDriveSize


        
        
Set-VM  -Name $vmCliName `
        -ProcessorCount $Processors `
        -ExposeVirtualizationExtensions $true

Add-VMDvdDrive -VMName $vmCliName -Path $isoPath 

#endregion

#region ....Check results...
Get-VM 
# The machine can also be started from the Hyper-V Manager with the CLI

Set-Location $env:windir\system
mmc virtmgmt.msc
 
 #endregion