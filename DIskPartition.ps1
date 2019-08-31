#Partion a disk
#https://blogs.technet.microsoft.com/heyscriptingguy/2013/05/29/use-powershell-to-initialize-raw-disks-and-to-partition-and-format-volumes/

get-disk | Format-Table -property number, BusType, PartitionStyle
$VolumeNumber = (get-Disk | Where-Object {$_.BusType -eq 'USB'}).number
$VolumeNumber
clear-disk -Number $VolumeNumber -RemoveData -RemoveOEM 
New-Partition -DiskNumber $VolumeNumber -UseMaximumSize -IsActive:$true -AssignDriveLetter 

Start-Sleep 10 

#Careful ----Format-Volume -FileSystem NTFS -NewFileSystemLabel "JJtest" -Confirm:$true

