Get-Help -Full 
Update-Help

Get-Command
Show-Command

Get-Member


Get-PSDrive

################################################################
Get-Command -Module PackageManagement  ###replaced OneGet

Get-PackageSource

Find-Package -OutVariable a
$a.count

$a | Out-GridView

Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco.exe upgrade chocolatey
Install-Package chocolateyTools

choco.exe 

Install-Package zoomit

Find-Module *cook*
Install-Module PowerShellCookbook -AllowClobber

Show-Command

Get-Command show-object

Get-ChildItem variable:*host*

$host | Show-Object

$Host.PrivateData.ErrorForegroundColor = [System.Windows.Media.Color]'#FF00F200'

help dir -path Cert:\CurrentUser -ShowWindow

Get-ChildItem -path Cert:\LocalMachine\My  


