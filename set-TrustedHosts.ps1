Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'gbi5x32,surface-jj,pc011-desktop,odyn1955,dell570'

$x = Get-Item WSMan:\localhost\Client\TrustedHosts

$x.Value