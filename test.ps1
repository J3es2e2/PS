
Get-CimSession | Remove-CimSession 

 
Get-Help *cim*
Get-Help New-CimSession -Full

$cim092 = New-CimSession -ComputerName '10.0.0.92'  -Credential 'JJJ'
$cim250 = New-CimSession -ComputerName '10.0.0.250' -Credential 'JJJessee'
$cim151 = New-CimSession -ComputerName '10.0.0.151' -Credential 'JJJessee'
$cim200 = New-CimSession -ComputerName '10.0.0.200' -Credential 'Owner'

$cim092
$cim250
$cim151
$cim200 | Get-Member | Format-Table -AutoSize
$cim200 | Get-CimClass Win32_SystemBIOS | Get-Member
Get-CimSession

Get-PSCallStack

#START Collectin CSV Output###########################################################################################

$currentTime = Get-Date
$BC = Get-CimSession | Get-CimInstance Win32_Bios
$bcOutput = $BC | ForEach-Object {
    [PSCustomObject]@{
        "SMBIOSBIOSVersion" = $_.SMBIOSBIOSVersion
        "Manufacturer" = $_.Manufacturer
        "Name" = $_.Name
        "SerialNumber"      = $_.SerialNumber 
        "Version"           = $_.Version
        "PSComputerName" = $_.PSComputerName
        "Date" = $currentTime
    }
}
$bcOutput | Export-Csv -Path "C:\Users\JJJ\BIOSVersion.csv" -Delimiter ";" -force -NoTypeInformation

Import-Csv -path "C:\Users\JJJ\BIOSVersion.csv"  -delimiter ";" | Format-Table -AutoSize

###########################################################################################
$currentTime = Get-Date
$CS = Get-CimSession | Get-CimInstance win32_computersystem
$csOutput = $CS | ForEach-Object {
    [PSCustomObject]@{
        "Name" = $_.Name
        "PrimaryOwnerName"          = $_.PrimaryOwnerName
        "Domain"                    = $_.Domain
        "TotalPhysicalMemory"       = $_.TotalPhysicalMemory
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
$csOutput | Export-Csv -Path "C:\Users\JJJ\ComputerSystem.csv" -Delimiter ";" -force -NoTypeInformation

Import-Csv -path "C:\Users\JJJ\ComputerSystem.csv"  -delimiter ";" | Format-Table -AutoSize

###########################################################################################
$currentTime = Get-Date
$DP = Get-CimInstance win32_diskPartition
$dpOutput = $DP | ForEach-Object {
    [PSCustomObject]@{
        "SystemName"       = $_.SystemName
        "DeviceID"         = $_.DeviceID
        "PrimaryPartition" = $_.PrimaryPartition
        "Size"             = $_.Size
        "Type"             = $_.Type
        "Blocksize"        = $_.Blocksize
        "Date"             = $currentTime
    }
}
$dpOutput | Export-Csv -Path "C:\Users\JJJ\DiskPartition.csv" -Delimiter ";" -force -NoTypeInformation

Import-Csv -path "C:\Users\JJJ\DiskPartition.csv"  -delimiter ";" | Format-Table -AutoSize

###########################################################################################
$currentTime = Get-Date
$LD = Get-CimInstance Win32_LogicalDisk
$ldOutput = $LD | ForEach-Object {
    [PSCustomObject]@{
        "SystemName"  = $_.SystemName
        "VolumeName"  = $_.VolumeName
        "DeviceID"    = $_.DeviceID       
        "Size"        = $_.Size
        "FreeSpace"   = $_.FreeSpace
        "Description" = $_.Description
        "Date"        = $currentTime
    }
}
$ldOutput | Export-Csv -Path "C:\Users\JJJ\LogicalDrives.csv" -Delimiter ";" -force -NoTypeInformation

Import-Csv -path "C:\Users\JJJ\LogicalDrives.csv"  -delimiter ";" | Format-Table -AutoSize

###########################################################################################
$currentTime = Get-Date
$NA = Get-CimInstance -ClassName win32_NetworkAdapter 
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
$naOutput | Export-Csv -Path "C:\Users\JJJ\NetAdapters.csv" -Delimiter ";" -force -NoTypeInformation

Import-Csv -path "C:\Users\JJJ\NetAdapters.csv"  -delimiter ";" | Format-Table -AutoSize

########################################################################################### 
$currentTime = Get-Date
$NAC = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration 
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
$nacOutput | Export-Csv -Path "C:\Users\JJJ\NetAdapterConfig.csv" -Delimiter ";" -Force -NoTypeInformation

Import-Csv -path "C:\Users\JJJ\NetAdapterConfig.csv" -delimiter ";" | Format-Table -AutoSize

#End CSV Collecting ##########################################################################################



Get-CimClass -ClassName win32_z*

$p = Get-CimClass -ClassName Win32_SystemDevices

Get-Command *cim* -CommandType Cmdlet | Sort-Object Noun

$winBios = (Get-CimSession | Get-CimInstance Win32_Bios)

$winOS = (Get-CimSession | Get-CimInstance Win32_OperatingSystem)

$winDisk = (Get-CimSession | Get-CimInstance win32_diskPartition)

$winDisk.

Get-CimInstance
















$c = @{ }
$c = @{"winOS" = (Get-CimSession | Get-CimInstance Win32_OperatingSystem); "winBios" = (Get-CimSession | Get-CimInstance Win32_Bios) }

$c.winBios
$c.winOS

$c.keys | ForEach-Object { $c.$_.CSName }

$c

$winOS.csname





 