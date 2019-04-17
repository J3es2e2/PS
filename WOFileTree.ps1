#name function Set-NewWorkOrder
#stub function Code
function New-Branch([string]$DirBranch) {
   try { Set-Location $DirBranch -ErrorAction Stop }
   catch {
      mkdir $DirBranch
      Set-Location $DirBranch
   }
}
 
#Set top Path
$TopPath = "C:\BSC Cookbook\QUOTES for CUSTOMERS\"
#make subdirectories
$Customer = Read-Host "Enter Customer Name"
$Location = Read-Host "Enter Job Location"
$WONumber = Read-Host "Enter WO Number"
New-Branch($TopPath)
New-Branch($Customer)
New-Branch($Location)
New-Branch($WONumber)
 
$WODirectory = $Customer + '_' + $Location + '_' + $WONumber

$SubDirectoryArray = @{ }
$SubDirectoryArray = Get-Content ($TopPath + 'WODirectory5.txt')  
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

 
 