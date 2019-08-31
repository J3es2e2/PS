ncpa.cpl

ipconfig /all >> "C:\Users\JJJ\PC011-IP.txt"

Get-WmiObject win32_bios
Get-CimInstance Win32_BIOS

(Get-WmiObject win32_operatingSystem).lastbootuptime

(Get-CimInstance win32_operatingSystem).lastbootuptime

$Cim = Get-CimInstance -ClassName CIM_OperatingSystem

$win32 = Get-CimInstance -ClassName win32_operatingsystem

Compare-Object $Cim $win32

Compare-Object $Cim $win32 -IncludeEqual

Get-WmiObject -Query 'Select Version from Win32_bios' | gm

Get-CimInstance -Query 'Select Version from Win32_bios' | gm

Get-CimInstance -Query 'Select Version from CIM_OperatingSystem'

Measure-Command { Get-CimInstance -Query 'Select Version from CIM_OperatingSystem'}


Measure-Command { 
    Get-CimInstance -Property Version -ClassName CIM_OperatingSystem
}


Measure-Command { 
    Get-WmiObject -Property Version -Class CIM_OperatingSystem
}

$DC = 'DELL570'
$SC = 'Surface-JJ'


$DCOM =   New-CimSession -ComputerName $SC -SessionOption $DCOM
$Default =   New-CimSession -ComputerName $SC 

$opt = New-CimSessionOption -Protocol Dcom
$DCOM = New-CimSession -ComputerName $sC -SessionOption $opt
$Default =   New-CimSession -ComputerName $SC 

Get-CimSession -ComputerName $SC





