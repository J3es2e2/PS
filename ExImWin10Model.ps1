
#select the VM to be exported, test for it's existance, and set a Path to export it to
$vmCliName = "Client_01"


get-vm -name $vmCliName

$exportPath = "E:\VM"

#export the VM to the Path
Export-VM -name $vmCliName01 -Path $exportPath


$importPath = "F:\VM\Client_01\Virtual Machines\47CBD3F2-B0D8-483E-A0E8-470AF1F57D32.vmcx"

#set new location
$newVMPath = "E:\NewVM"

Import-VM -path $importPath -VirtualMachinePath $newVMPath -VhdDestinationPath $newVMPath -Copy -GenerateNewId
