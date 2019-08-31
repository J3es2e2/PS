mkdir C:\test
Get-Process | Out-File -FilePath c:\test\p1.txt

mkdir C:\test2
Copy-Item -Path C:\test\p1.txt -Destination C:\test2\ -PassThru

2..10 | ForEach-Object {
   $newname = "p$_.txt"
   Copy-Item -Path C:\test\p1.txt -Destination C:\test2\$newname -PassThru
}

2..10 | ForEach-Object {
   $deletename = "p$_.txt"
   Remove-Item -Path C:\test2\$deletename 
}

Copy-Item -Path "C:\Users\JJJessee\JJLab\psScript\*.ps1" -Recurse -passthru

Get-Help get-childitem -full
$x = Get-ChildItem "C:\Users\JJJessee\JJLab\psScript\*.ps1" -recurse
$x | Get-Member
$x.fullname
$x.name




$getOS = New-CimSession
$getOS
$osOutput = Get-CimInstance Win32_OperatingSystem
$osOutput | Get-Member
$osOutput.OSArchitecture
$osOutput.Version
$osOutput.Description
$osOutput.SerialNumber
$osOutput.ServicePackMajorVersion
$osOutput.ServicePackMinorVersion
$osOutput.InstallDate
$osOutput.BuildType
$osOutput.BuildNumber


Install-Package Microsoft.PowerShell.SDK -Version 6.2.0-preview.3 -Source https://powershell.myget.org/F/powershell-core/api/v3/index.json

1..5 | ForEach-Object { $_ | Join-String -OutputPrefix ‘File’ -OutputSuffix ‘.txt’ }

Get-Volume |
Where-Object DriveLetter |
Sort-Object Driveletter |
ForEach-Object {
   Get-DiskSpace -DriveLetter “$($_.Driveletter):” |
   Select-Object DriveName, TotalSizeUnitSize, UsedSpaceUnitSize, 
   AvailableFreeSpaceUnitSize, UsedSpacePercent, AvailableFreeSpacePercent   
}

Find-Module NTFSSecurity
Install-Module NTFSSecurity
Import-Module NTFSSecurity

Get-Command -noun *html*
ConvertTo-Html -InputObject (Get-Date)

function get-firstnonrepeatcharacter {
   [CmdletBinding()]
   param (
      [string]$teststring
   )

   $a = [ordered]@{ }

   $teststring.ToLower().ToCharArray() |
   ForEach-Object {
      if ($a.$psitem) {
         $a.$psitem += 1
         $a
         $a.$psitem
      }
      else {
         $a += @{$psitem = 1 }
      }

   }

   $a.GetEnumerator() | Where-Object Value -eq 1 | Select-Object -First 1

}

get-firstnonrepeatcharacter -teststring "bnm,mnbmnbbnnb,hffhfhfhuasdasda"



$ts = 'ffrluoluntlvxutxbdvbktgyyvsvcrkxoyfotzkzogcwuwycmnhuedk'
$ts.ToCharArray() | Group-Object



function measure-vowel {
   [CmdletBinding()]
   param (
      [string]$teststring
   )

   $counts = [ordered]@{
      Vowels      = 0
      Consonants  = 0
      NonAlphabet = 0
   }
   
   $vowels = 97, 101, 105, 111, 117    
   
   $teststring.ToLower().ToCharArray() |
   ForEach-Object {
      $test = [byte]$psitem

      switch ($test) {
         { $test -in $vowels } { $counts.Vowels += 1; break }
         { $test -ge 97 -and $test -le 122 } { $counts.Consonants += 1; break }
         default { $counts.NonAlphabet += 1; break }
      }

   }

   New-Object -TypeName PSObject -Property $counts

}
measure-vowel -teststring "askdjfhaslkjdoqiuweyriwu"

$cred = Get-Credential -Credential PC011-Desktop\JJJ 

$s = New-PSSession -ComputerName '10.0.0.92' -Credential $cred
$s

Get-Help save-help -Full

Get-PackageSource
Install-Package zoomit
