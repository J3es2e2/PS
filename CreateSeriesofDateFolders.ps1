#Create an array of empty folders with Date-based folder names
$pathToAppend = "C:\BSC Cookbook\Payroll 2020\"
$folderSuffix = " Payroll"
$folderPrefix = "" 
$howManyFolders = 25
$offsetDaysFromToday = 9
$intravalDays = 7
$arrayOfFolders = @()

for ($i = 0
   $i -lt $howManyFolders
   $i++) {
   $arrayOfFolders += $folderPrefix + ((Get-Date).AddDays(($i * $intravalDays) + $offsetDaysFromToday ).ToString("MM-dd-yyyy")) + $folderSuffix
}

foreach ($foldername in $arrayOfFolders) {
   $mf = $pathToAppend + $foldername
   New-Item -ItemType 'directory' -path  $mf 
}
#command to open file explorer and verify results
#command to display created folders via PS
#command to erase the folders


