#used primarily to change all files with a target WO# with a newValue

Set-Location 'C:\BSC Cookbook\QUOTES for CUSTOMERS\'
Get-ChildItem -attributes 'D'  
$companyDir = Read-Host "Enter ABC Directory search string"
Set-Location .\$companyDir
$companyDir = Read-Host "Enter Company search string"
$DirArray = Get-ChildItem $companyDir -attributes 'D'  
$dirDisplay = @()
for ($i = 0; $i -lt $DirArray.Count; $i++) {
   $dirDisplay += ($i.ToString() + ' ' + $DirArray.name[$i])
}
$dirDisplay
$dirIndex = Read-Host "Enter Directory index"
Set-Location $DirArray[$dirIndex].name
Get-ChildItem

Set-Location 'C:\BSC Cookbook\QUOTE S for CUSTOMERS\KVAT\TEST TN'

$target = Read-Host "Number to be replaced is"
$newValue = Read-Host "Replacement number is"

Get-ChildItem -recurse | Where-Object { $_.name.Contains($target) } | ForEach-Object { Rename-Item $_ -NewName $_.name.Replace($target, $newValue) }
