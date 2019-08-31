<#
Attempting to collect info from WMI (CIM) classes on a remote computer
Has the same Network (10.0.0.x)
The request is being made from a Win 10 machine
The request is made of a 2016 Win Server EVAL machine
Access is denied unless -Credential "Administrator" is used
Other users of the Administrator group are denied. 
Both machines are visible and accessible via Windows Explorer 
Both machines are have been made Trusted Hosts of each other via WinRM

My prefrence is to not to supply credential for the moment since I'm 
just operating in a lab environment

Suggestions?
#>


#Start PS-Execution  
  
$Results = @()  
$Computer = Get-Content .\NetBIOS.txt  
  
#Run Command Concurrently for each machine in NetBIOS.txt list  
   
ForEach ($Computer in $Computer) { 
   $Computer 
   $Properties = @{  
      NetBIOS_Name        = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer  | select -ExpandProperty CSName  
      OS_Name             = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer | Select-Object -ExpandProperty Caption   
      OS_Architecture     = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer | select -ExpandProperty OSArchitecture  
      System_Manufacturer = Get-WmiObject win32_computersystem -ComputerName $Computer | select -ExpandProperty Manufacturer  
      Model               = Get-WmiObject win32_computersystem -ComputerName $Computer | select -ExpandProperty Model  
      CPU_Manufacturer    = Get-WmiObject Win32_Processor -ComputerName $Computer | select -ExpandProperty Name  
      Disk_Size_GB        = Get-WmiObject win32_diskDrive -ComputerName $Computer | Measure-Object -Property Size -Sum | % {[math]::round(($_.sum / 1GB), 2)}  
      Physical_Memory_GB  = Get-WMIObject -class Win32_PhysicalMemory -ComputerName $Computer | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1GB), 2)} 
      Serial_Number       = Get-WmiObject Win32_BIOS -ComputerName $Computer | Select -ExpandProperty SerialNumber 
   }  
   $Results += New-object psobject -Property $Properties  
} $Results | Select-Object NetBIOS_Name, OS_Name, OS_Architecture, System_Manufacturer, Model, CPU_Manufacturer, Disk_Size_GB, Physical_Memory_GB, Serial_Number | Export-csv -Path .\Machine_Inventory_$((Get-date).ToString('MM-dd-yyyy')).csv -NoTypeInformation 

<##########
get-WmiObject -Class * 
Get-CimClass -ClassName *provider*

Get-CimInstance -ClassName __Win32Provider | sort Name | select Name
Get-CimInstance -ClassName __NAMESPACE -Namespace root | sort Name
Get-WmiObject -Namespace root -class *service* -recurse list

$class = Get-CimClass -ClassName Win32_Service 
$class

$class.CimClassProperties

#class key
foreach ($property in $class.CimClassProperties) {
   $property | select -ExpandProperty Qualifiers |
      foreach {
      if ($_.Name -eq 'key') {$property}
   }

}

$class.CimClassMethods
$class.CimClassMethods['Create'].Parameters

Get-CimInstance -ClassName win32_Service | sort Name

Get-CimInstance -ClassName Win32_OperatingSystem | gm

$winOS = Get-CimInstance -ClassName Win32_OperatingSystem | select -ExpandProperty 



Get-CimClass -ClassName *event*

help Get-Disk -Full
#>