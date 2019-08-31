

####################################################
Find-Module *cook*

Install-Module PowerShellCookbook

Get-Command Show-Object
####################################################

$Host | Show-Object

$Host.UI.RawUI.WindowTitle

$host

$Host.UI.RawUI.WindowTitle = "POWERSHELL ROCKS!"

$Host.PrivateData.ErrorForegroundColor = bnmbnb

$Host.PrivateData.ErrorForegroundColor = [System.Windows.Media.Color]'#FF00F200'
$Host.PrivateData.ErrorForegroundColor = [System.ConsoleColor]'green'

[System.ConsoleColor] | Get-Member

Get-Help [System.Windows.Media.Color]


$x = [System.ConsoleColor]'green'

Show-Command