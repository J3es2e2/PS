function Get-MyProcess { Get-Process @Args }
Get-MyProcess -Name powershell_ise

Get-Process -Name powershell_ise

Get-MyProcess -Name PowerShell_Ise -FileVersionInfo

function Get-MyCommand {
   Param ([switch]$P, [switch]$C)
   if ($P) { Get-Process @Args }
   if ($C) { Get-Command @Args }
}

Get-MyCommand  -P -C -Name PowerShell_Ise