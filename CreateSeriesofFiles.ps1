#Create an array of files starting with an index number
$RemoteSurface = "Surface-JJ"
   Invoke-Command -ComputerName $RemoteSurface { 
   $pathToAppend = "C:\BSC Cookbook\2019 BSC\BSC Checks 2019\"
   $pathToAppend = "C:\tempCHKS\"
   $SeedPDF = "BlankPDF.pdf"
   $fileSuffix = " CHKBLANK xxxxx.pdf"
   $filePrefix = $null 
   $endNumber = 83900
   $startNumber = 83845
   
   $arrayOfFiles = @()

   cls

   for ($i = $startNumber
      $i -le $endNumber
      $i++) {
      $arrayOfFiles += $filePrefix + ($i) + $fileSuffix
   }
   $arrayOfFiles

   foreach ($fileName in $arrayOfFiles) {
      $mf = ($pathToAppend + $FileName)
      Copy-Item ($pathToAppend + $SeedPDF)  -Destination $mf       
   }
   #command to open file explorer and verify results
   #command to display created files
   #command to erase the files


} -Credential 'JJJessee'