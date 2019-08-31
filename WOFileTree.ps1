#name function Set-NewWorkOrder
#stub function Code
function New-Branch([string]$DirBranch) {
   try { Set-Location $DirBranch -ErrorAction Stop }
   catch {
      mkdir $DirBranch
      Set-Location $DirBranch
   }
}
cls
$a = ''
$ABCDirectories = @()
$ABCdir = @()
$Customer = ''
$SearchForABCDir = ''
$TopPathPlus = @()
$TargetDir = @()

#Set top Path
$TopPath = "C:\BSC Cookbook\QUOTES for CUSTOMERS\"
Set-Location $TopPath

$ABCDirectories = Get-ChildItem -Attributes 'D' 
$ABCDirectories | format-wide

#make subdirectoriesGPM
$Customer = Read-Host "Search for Customer Name"

# find the correct alphabet folder
$SearchForABCDir = $Customer.Substring(0, 1).ToUpper()
$ABCdir = Get-ChildItem -Attributes 'D' -name | Where-Object { $PSItem.Contains($SearchForABCDir) }

#$TopPathPlus = $ABCdir 
Set-Location  $ABCdir 
#$ExistingABCDir = Get-ChildItem -Include ($SearchForABCDir + '*') -Attributes 'D' -Name

$TargetDir = Get-ChildItem  -Attributes 'D'  
Get-ChildItem -Directory | format-wide -AutoSize
#$TargetDir.Name

If ($TargetDir.name.contains($Customer)) {
   Set-Location $Customer
}
else {
   $UseCustomer = Read-Host 'Use '  $Customer ' as the New Customer Folder Name? y/n'
   If ($UseCustomer.ToLower() = 'y') {
      New-Branch($Customer)
   }
   else {
      Do { $NewCustomer = Read-Host "Enter the New Customer Folder Name " } While (!($TargetDir.name.contains($a)))
      New-Branch($NewCustomer)
   }
}   
####################################################

Get-ChildItem -Directory | format-wide -AutoSize
$Location = Read-Host "Enter Job Location"
$WONumber = Read-Host "Enter WO Number"
New-Branch($Location)
New-Branch($WONumber)
 
$WODirectory = $Customer + '_' + $Location + '_' + $WONumber

$SubDirectoryArray = @{ }
$SubDirectoryArray = Get-Content ($TopPath + 'WODirectory.txt') 
$SubDirectoryArray | ForEach-Object {
   mkdir -path ($PSItem + $WODirectory)
}
#Setup blank Spreadsheet template
[string]$SSTemplate = Read-Host "Do you want to add a blank proposal template? (y/n)"
if ($SSTemplate.tolower() -eq 'y') {
   $PropTemp = "Proposal Template 2019.xls"
   $ProposalTemplate = $WODirectory + ".xls" 
   Set-Location ($SubDirectoryArray[3] + $WODirectory)
   Copy-Item -path ( $TopPath + $PropTemp ) -Destination ($ProposalTemplate)
}
#add try -catch

 
#add Excel prep-edit funtion

<#
https://social.technet.microsoft.com/Forums/lync/en-US/abcf63ba-ce01-4e91-8bad-d5c42d2234e9/how-to-write-in-excel-via-powershell?forum=winserverpowershell

$xl=New-Object -ComObject Excel.Application
$wb=$xl.WorkBooks.Open('C:\Temp\Servers.xls')
$ws=$wb.WorkSheets.item(1)
$xl.Visible=$true

$ws.Cells.Item(1,1)=1

$wb.SaveAs('c:\temp\Servers_New.xls')
$xl.Quit() 
#>