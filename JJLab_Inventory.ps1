
Get-CimSession | Remove-CimSession 

#check ipconfig to make sure desired CimSessions are a trusted host
winrm.cmd set winrm/config/client '@{TrustedHosts = "10.0.0.250,10.0.0.151,10.0.0.92,10.0.0.200,10.0.0.225"}'

$cim092 = New-CimSession -ComputerName '10.0.0.92'  -Credential 'JJJ'
$cim250 = New-CimSession -ComputerName '10.0.0.250' -Credential 'JJJessee'
$cim151 = New-CimSession -ComputerName '10.0.0.151' -Credential 'JJJessee'
$cim200 = New-CimSession -ComputerName '10.0.0.200' -Credential 'Owner'
$cim225 = New-CimSession -ComputerName '10.0.0.225' -Credential 'jj@bristolsign.com'

$cim092
$cim250
$cim151
$cim200
$cim225
Get-CimSession

$Path = "C:\Users\JJJessee\JJLab\"

#START Collectin CSV Output###########################################################################################

$currentTime = Get-Date
$BC = Get-CimSession | Get-CimInstance Win32_Bios
$bcOutput = $BC | ForEach-Object {
   [PSCustomObject]@{
      "SMBIOSBIOSVersion" = $_.SMBIOSBIOSVersion
      "Manufacturer"      = $_.Manufacturer
      "SerialNumber"      = $_.SerialNumber 
      "Version"           = $_.Version
      "PSComputerName"    = $_.PSComputerName
      "Date"              = $currentTime
   }
}
$bcOutput | Export-Csv -Path ($Path + "BIOSVersion.csv") -Delimiter ";" -force -NoTypeInformation

Import-Csv -path ($Path + "BIOSVersion.csv")  -delimiter ";" | Format-Table -AutoSize

###########################################################################################
$currentTime = Get-Date
$CS = Get-CimSession | Get-CimInstance win32_computersystem
$csOutput = $CS | ForEach-Object {
   [PSCustomObject]@{
      "Name"                      = $_.Name
      "PrimaryOwnerName"          = $_.PrimaryOwnerName
      "Domain"                    = $_.Domain
      "TotalMemory(GB)"           = [math]::Round($_.TotalPhysicalMemory / 1GB, 2)
      "Model"                     = $_.Model
      "Manufacturer"              = $_.Manufacturer
      "PSComputerName"            = $_.PSComputerName   
      "DomainRole"                = $_.DomainRole
      "BootROMSupported"          = $_.BootROMSupported
      "NumberOfProcessors"        = $_.NumberOfProcessors
      "NumberOfLogicalProcessors" = $_.NumberOfLogicalProcessors
      "Date"                      = $currentTime
   }
}
$csOutput | Export-Csv -Path ($Path + "ComputerSystem.csv") -Delimiter ";" -force -NoTypeInformation

Import-Csv -path ($Path + "ComputerSystem.csv")  -delimiter ";" | Format-Table -AutoSize


## SIDDAWAY SECTION #########################################################################################
$currentTime = Get-Date
$diskinfo = Get-CimSession | Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3" |

ForEach-Object {
   $props = $null
   
   $part = Get-CimAssociatedInstance -InputObject $psitem -ResultClass Win32_DiskPartition
   $disk = Get-CimAssociatedInstance -InputObject $part -ResultClassName Win32_DiskDrive
   
   $props = [ordered]@{
      SystemName          = $disk.SystemName
      Disk                = $disk.Index
      Model               = $disk.Model
      Firmware            = $disk.FirmwareRevision
      SerialNUmber        = $disk.SerialNumber
      'DiskSize(GB)'      = [math]::Round(($disk.Size / 1GB ), 2)
      Partitions          = $disk.Partitions
      Partition           = $part.index
      BootPartition       = $part.BootPartition
      'PartitionSize(GB)' = [math]::Round(($part.Size / 1GB ), 2)
      Blocks              = $part.NumberOfBlocks
      BlockSize           = $part.BlockSize
      LDiskName           = $psitem.Caption
      FileSystem          = $psitem.FileSystem
      LDiskSize           = [math]::Round(($psitem.Size / 1GB ), 2)
      LDiskFree           = [math]::Round(($psitem.FreeSpace / 1GB ), 2)
      INVDATE             = $currentTime
   }

   New-Object -TypeName PSObject -Property $props

}
$diskinfo | Export-Csv -Path ($Path + "LogicalDrives.csv") -Delimiter ";" -force -NoTypeInformation

Import-Csv -path ($Path + "LogicalDrives.csv")  -delimiter ";" | Format-Table -AutoSize

###########################################################################################
$currentTime = Get-Date
$NA = Get-CimSession | Get-CimInstance -ClassName win32_NetworkAdapter 
$naOutput = $NA | ForEach-Object {
   [PSCustomObject]@{
      "InterfaceIndex"  = $_.InterfaceIndex
      "MACAddress"      = $_.MACAddress
      "SystemName"      = $_.SystemName
      "DeviceID"        = $_.DeviceID
      "Name"            = $_.Name
      "PhysicalAdapter" = $_.PhysicalAdapter
      "AdapterType"     = $_.AdapterType
      "Date"            = $currentTime
   }
}
$naOutput | Export-Csv -Path ($Path + "NetAdapters.csv") -Delimiter ";" -force -NoTypeInformation

Import-Csv -path ($Path + "NetAdapters.csv")  -delimiter ";" | Format-Table -AutoSize

########################################################################################### 
$currentTime = Get-Date
$NAC = Get-CimSession | Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration 
$nacOutput = $NAC | ForEach-Object {
   [PSCustomObject]@{

      "InterfaceIndex"   = $_.InterfaceIndex        
      "IPAddress"        = ($_.IPAddress -join ',')
      "IPSubnet"         = ($_.IPSubnet -join ',')
      "DefaultIPGateway" = ($_.DefaultIPGateway -join ',')
      "Description"      = $_.Description
      "DHCPEnabled"      = $_.DHCPEnabled
      "DHCHLeaseExpires" = $_.DHCHLeaseExpires
      "Date"             = $currentTime 
   }
}
$nacOutput | Export-Csv -Path ($Path + "NetAdapterConfig.csv") -Delimiter ";" -Force -NoTypeInformation

Import-Csv -path ($Path + "NetAdapterConfig.csv") -delimiter ";" | Format-Table -AutoSize

#End CSV Collecting ##########################################################################################

$csOutput | ConvertTo-Html > ($Path + 'ComputerInfo.html')

$bcOutput | ConvertTo-Html >> ($Path + 'ComputerInfo.html')

$diskinfo | ConvertTo-Html >> ($Path + 'ComputerInfo.html')

$naOutput | ConvertTo-Html >> ($Path + 'ComputerInfo.html')

Invoke-Item ($Path + 'ComputerInfo.html')


<##### APPENDICES  #####################################################################
Get-Help *cim*
Get-Help New-CimSession -Full
Get-CimInstance
Get-CimSession
Get-Help ConvertTo-Html -full

#######################################################################################>
