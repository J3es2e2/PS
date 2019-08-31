$PSDefaultParameterValues = @{'get-help:full' = $true }
$PSDefaultParameterValues = @{'get-help:showwindow' = $true }

Measure-Command -Expression { notepad.exe; notepad.exe; notepad.exe; Get-Process -name notepad | Stop-Process }
Get-Process -Name * | ForEach-Object { $PSItem.name.ToUpper() }

$names = Get-Content .\NAMESFILE.txt
$names[1]
$outputfile = (Get-Location).path + '.\outputtest.txt'
$outputfile
Remove-Item $outputfile
New-Item $outputfile -ItemType file
try {
   $writer = [System.IO.StreamWriter] $outputfile
   $writer.WriteLine("Hello " + $names[1] + "and all.")
   $writer.Close()
}
catch {
   Write-Host "oops"
}
