#region Step 0 Define globals 
#$Server = 'PC011-DESKTOP'
$Server = '192.168.1.150'
$Credentials = Get-Credential
$Users = 'C:\Users' 

#endregion

#region Step 1 Basic code
$userProfileSize = (Get-ChildItem -Path  $Users -File -Recurse | Measure-Object -Property Length -Sum).Sum 

[math]::Round($userProfileSize / 1GB, 2)

(Get-CimInstance -ComputerName $Server -ClassName win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPaddress[0]

(Get-CimInstance -ComputerName $Server -ClassName Win32_OperatingSystem).Caption

(Get-CimInstance -ComputerName $Server -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB

(Get-CimInstance -ComputerName $Server -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID, @{Name = 'Freespace'; Expression = { [Math]::Round(($_.Freespace / 1GB), 2) } } | Measure-Object -Property Freespace -Sum).Sum

Invoke-Command -ComputerName $Server -ScriptBlock {
    (Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Measure-Object).Count
}
#endregion

#region Step 2 Create as an object

$output = @{ }
$output = @{
    'ServerName'               = $null
    'IPAdress'                 = $null
    'OperatingSystem'          = $null
    'AvailableDriveSpace (GB)' = $null
    'Memory (GB)'              = $null
    'UserProfileSize (MB)'     = $null
    'StoppedServices'          = $null
}
[PSCustomObject]$output

$output.'ServerName' = $Server

$output.'IPAdress' = (Get-CimInstance -ComputerName $Server -ClassName win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPaddress[0]

$output.'OperatingSystem' = (Get-CimInstance -ComputerName $Server -ClassName Win32_OperatingSystem).Caption

$output.'AvailableDriveSpace (GB)' = (Get-CimInstance -ComputerName $Server -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID, @{Name = 'Freespace'; Expression = { [Math]::Round(($_.Freespace / 1GB), 2) } } | Measure-Object -Property Freespace -Sum).Sum

$output.'Memory (GB)' = (Get-CimInstance -ComputerName $Server -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB

$userProfileSize = (Get-ChildItem -Path  $Users -File -Recurse | Measure-Object -Property Length -Sum).Sum  
$output.'UserProfileSize (MB)' = [math]::Round($userProfileSize / 1MB, 2)

$output.'StoppedServices' = Invoke-Command -ComputerName $Server -ScriptBlock {
    (Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Measure-Object).Count
}

[PSCustomObject]$output

#endregion

#region 3 first Refactor 

$getCimInstParams = @{
    CimSession = (New-CimSession -ComputerName $Server -Credential $Credentials)
}

$output = @{
    'ServerName'               = $null
    'IPAdress'                 = $null
    'OperatingSystem'          = $null
    'AvailableDriveSpace (GB)' = $null
    'Memory (GB)'              = $null
    'UserProfileSize (MB)'     = $null
    'StoppedServices'          = $null
}
[PSCustomObject]$output

get-help New-CimSession -Full

$output.'ServerName' = $Server

$output.'IPAdress' = (Get-CimInstance @getCimInstParams -ClassName win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPaddress[0]

$output.'OperatingSystem' = (Get-CimInstance @getCimInstParams -ClassName Win32_OperatingSystem).Caption

$output.'AvailableDriveSpace (GB)' = (Get-CimInstance @getCimInstParams -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID, @{Name = 'Freespace'; Expression = { [Math]::Round(($_.Freespace / 1GB), 2) } } | Measure-Object -Property Freespace -Sum).Sum

$output.'Memory (GB)' = (Get-CimInstance @getCimInstParams -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB

$userProfileSize = (Get-ChildItem -Path  $Users -File -Recurse | Measure-Object -Property Length -Sum).Sum 
$output.'UserProfileSize (MB)' = [math]::Round($userProfileSize / 1MB, 2) 

$output.'StoppedServices' = Invoke-Command -ComputerName $Server -ScriptBlock {
    (Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Measure-Object).Count
}

[PSCustomObject]$output

Remove-CimSession @getCimInstParams

#endregion

#region Step 4 BEST WAY Invoke-command on servers simultaneously
GBI5X32 192.168.1.10 JJJ
LENOVO-TC 192.168.1.150 JJJ
SURFACE-JJ 192.168.1.160 JJJ
PC011-DESKTOP 192.168.1.170 JJJ
DELL570 192.168.1.180 JJJ

$Servers = ('192.168.1.10', '192.168.1.150', '192.168.1.160','192.168.1.170','192.168.1.180')

$scriptBlock = {

    $output = @{ }
    $output = @{
        'ServerName'               = (hostname)
        'IPAdress'                 = $null
        'OperatingSystem'          = $null
        'AvailableDriveSpace (GB)' = $null
        'Memory (GB)'              = $null
        'UserProfileSize (GB)'     = $null
        'StoppedServices'          = $null
    }
    #[PSCustomObject]$output
   
    $userProfileSize = (Get-ChildItem -Path  'C:\Users' -File -Recurse | Measure-Object -Property Length -Sum).Sum 
    $output.'UserProfileSize (GB)' = [math]::Round($userProfileSize / (1GB), 2) 

    $output.'IPAdress' = (Get-CimInstance -ClassName win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPaddress[0]

    $output.'OperatingSystem' = (Get-CimInstance   -ClassName Win32_OperatingSystem).Caption

    $output.'AvailableDriveSpace (GB)' = (Get-CimInstance   -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID, @{Name = 'Freespace'; Expression = { [Math]::Round(($_.Freespace / 1GB), 2) } } | Measure-Object -Property Freespace -Sum).Sum

    $output.'Memory (GB)' = (Get-CimInstance   -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB

    $output.'StoppedServices' = (Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Measure-Object).Count
  
    [PSCustomObject]$output
}

$icmParams = @{
    ComputerName = $Servers[4]
    ScriptBlock  = $scriptBlock
    Credential   = $Credential
}
 

Invoke-Command @icmParams | Select-Object -Property * -ExcludeProperty 'runSpaceId', 'PSComputerName', 'PSShowComputerName'
     
#[PSCustomObject]$output

#endregion