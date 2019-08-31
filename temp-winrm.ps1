winrm get winrm/config
$computers = 'odyn1955,dell570,pc011-desktop,surface-jj'
set-item WSMan:\localhost\Client\TrustedHosts -Value $computers 

winrs -r:odyn1955 ipconfig /all
winrs -r:dell570-jj ipconfig /all