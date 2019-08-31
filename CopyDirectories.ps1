#TO create a duplicate set of directory folders such as Vendor Folders when beginning a new year

$TargetDir = @()
cls
 
$TopPath = "C:\BSC Cookbook\2019 BSC\BSC Vendor Bills 2019"
Set-Location $TopPath
$TargetDir = Get-ChildItem  -Attributes 'D'  

$pathToAppend = "C:\BSC Cookbook\2020 BSC\BSC Vendor Bills 2020\"
New-Item -ItemType 'directory' -path  $pathToAppend
Set-Location $pathToAppend

foreach ($Target in $TargetDir) {
   $mf = $pathToAppend + $Target
   New-Item -ItemType 'directory' -path  $mf 
}