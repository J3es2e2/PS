Enable-PSRemoting -SkipNetworkProfileCheck -

Get-Item WSMan:\localhost\Client\TrustedHosts


Set-Item WSMan:\localhost\Client\TrustedHosts "DELL570, Surface-JJ, PC011-Desktop"

Enter-PSSession -ComputerName PC011-Desktop -Credential JJJ

Exit-PSSession
