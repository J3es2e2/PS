#source: https://github.com/DeploymentResearch/DRFiles/blob/master/Scripts/Create-WS2016RefImage.ps1

# Note #1: 
# To service a newer version of WinPE than the OS you are servicing from, for example service Windows 10 v1709 
# from a Windows Server 2016 server, you need a newer DISM version.
# Solution, simply install the latest Windows ADK 10, and use DISM from that version
#
# Note #2:
# If your Windows OS already have a newer version of dism, uncomment the below line, and comment out line 11 and 12
# $DISMFile = 'dism.exe'

$DISMFile = 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM\dism.exe'
#If (!(Test-Path $DISMFile)){ Write-Warning "DISM in Windows ADK not found, aborting..."; Break }


#JJ changed :
#the drive letters from E: to C: 
#added the necessary directories
#used a recently downloaded 2016 server ISO
#and downloaed LCU and SSU files
$ISO = "C:\ISO\Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO"
$LCU = "c:\Setup\LCU\windows10.0-kb4487006-x64_464f910dd8b67c3cbd36e2a8da20204b9dd659a6.msu"
$SSU = "c:\Setup\SSU\windows10.0-kb4485447-x64_e9334a6f18fa0b63c95cd62930a058a51bba9a14.msu"
$MountFolder = "c:\Mount"
$RefImageFolder = "c:\Setup"
$TmpImage = "$RefImageFolder\tmp_install.wim"
$RefImage = "$RefImageFolder\REFWS2016-001.wim"

# Verify that the ISO and CU files existnote
if (!(Test-Path -path $ISO)) {Write-Warning "Could not find Windows Server 2016 ISO file. Aborting..."; Break}
if (!(Test-Path -path $SSU)) {Write-Warning "Could not find servicing stack Update for Windows Server 2016. Aborting..."; Break}
if (!(Test-Path -path $LCU)) {Write-Warning "Could not find Cumulative Update for Windows Server 2016. Aborting..."; Break}
if (!(Test-Path -path $MountFolder)) {New-Item -path $MountFolder -ItemType Directory}
if (!(Test-Path -path $RefImageFolder)) {New-Item -path $RefImageFolder -ItemType Directory}

# Mount the Windows Server 2016 ISO
Mount-DiskImage -ImagePath $ISO
$ISOImage = Get-DiskImage -ImagePath $ISO | Get-Volume
$ISODrive = [string]$ISOImage.DriveLetter + ":"
 
# Export the Windows Server 2016 Standard index to a new WIM
Export-WindowsImage -SourceImagePath "$ISODrive\Sources\install.wim" -SourceName "Windows Server 2016 SERVERSTANDARD" -DestinationImagePath $TmpImage

# Mount the image
Mount-WindowsImage -ImagePath $TmpImage -Index 1 -Path $MountFolder  

# Add the latest SSU to the Windows Server 2016 Standard image
Add-WindowsPackage -PackagePath $SSU -Path $MountFolder
 
# Add the latest CU (LCU) to the Windows Server 2016 Standard image
Add-WindowsPackage -PackagePath $LCU -Path $MountFolder

# Cleanup the image BEFORE installing .NET to prevent errors
# Using the /ResetBase switch with the /StartComponentCleanup parameter of DISM.exe on a running version of Windows removes all superseded versions of every component in the component store.
# https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder#span-iddismexespanspan-iddismexespandismexe
&  $DISMFile /Image:$MountFolder /Cleanup-Image /StartComponentCleanup /ResetBase

# Add .NET Framework 3.5.1 to the Windows Server 2016 Standard image
Add-WindowsPackage -PackagePath $ISODrive\sources\sxs\microsoft-windows-netfx3-ondemand-package.cab -Path $MountFolder

# Re-apply latest CU (LCU) because of .NET changes
Add-WindowsPackage -PackagePath $LCU -Path $MountFolder
 
# Dismount the Windows Server 2016 Standard image
DisMount-WindowsImage -Path $MountFolder -Save

# Export the Windows Server 2016 index to a new WIM (the export operation reduces the WIM size with about 100 MB or so)
Export-WindowsImage -SourceImagePath $TmpImage -SourceIndex "1" -DestinationImagePath $RefImage

# Remove the temporary WIM
if (Test-Path -path $TmpImage) {Remove-Item -Path $TmpImage -Force}

 
# Dismount the Windows Server 2016 ISO
Dismount-DiskImage -ImagePath $ISO