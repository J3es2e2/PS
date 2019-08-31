<#
Become Hardcore Extreme Black Belt PowerShell Ninja Rockstar
Script # 1

Goal: Measure, Log, and Analysis The FreeSpace on a Disk Drive Over time.
On a local machine, on a daily or occasional basis record the space used and free space of  disk drive and log it into a .csv file, do basic statistics, generate an HTML format report and email to admin
#>

# Use the C: Drive on the local computer.
# Create and store the .csv file as Computername_FreespaceLog.csv
# Data to record: VolumeSerialNumber, DriveId, DriveCapacity, FreeSpace, TimeStamp
# Analytics to report: SpaceUsed, %Freespace, FreeSpaceChange, RateofChange
# Email Report

Get-Command *csv*
get-help export-csv -full
$Computer = 'Surface-JJ'

$Path = 'C:\Users\JJJessee\JJLab\psScript\FreeDiskSpaceLog'
$FileName = '\' + $Computer + '_FreespaceLog.csv'
 
$TimeStampA = Get-Date
$Disk = get-wmiobject win32_LogicalDisk -Filter "DriveType = 3" | Select VolumeSerialNumber, DeviceID, { [math]::round(($_.FreeSpace / 1GB), 2) }, { [math]::round(($_.Size / 1GB), 2) }

$TimeStampA = Get-Date
 



$TimeStampB = Get-Date
 

$lapse = $TimeStampB - $TimeStampA



Get-CimInstance Win32_LogicalDisk -PipelineVariable disk 

Get-Command -Type Cmdlet | Sort-Object -noun *Certificate*
 
Get-help get-Certificate